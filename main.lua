-- Agility Helper: highlights the next obstacle to click on an agility course
-- and tracks laps.
--
-- A course loads when the player comes within LOAD_RANGE tiles of its start
-- and unloads beyond UNLOAD_RANGE. While loaded, progress is tracked in two
-- steps so misclicks don't advance the course:
--   1. Clicking a course obstacle marks it as pending.
--   2. The next Agility XP gain confirms it and moves the highlight on.
-- The lap-completion bonus arrives with nothing pending, so it is ignored.
-- A lap runs from the click on the first obstacle to the XP for the last.

local const = require("constants")
local panel = require("ui")
-- The API also has a global named ui; make sure require found our file.
assert(type(panel) == "table" and panel.create, "require(\"ui\") did not load ui.lua")

-- Plugins can't write files, so the console is the only log.
local function debugLog(fmt, ...)
    if const.DEBUG then print(string.format(fmt, ...)) end
end

debugLog("Agility Helper loaded")

-- Every course with its generated model outlines, keyed by file name.
local courses = {}
for _, file in ipairs(const.COURSES) do
    courses[file] = { data = require("courses/" .. file), models = require("models/" .. file) }
end

local active = nil       -- loaded course from courses, nil when away from all courses
local course = nil       -- active.data, the loaded course's obstacles and routes
local route = nil        -- route being followed on the loaded course
local nextIndex = 1      -- position in route of the obstacle to highlight
local pendingIndex = nil -- clicked obstacle waiting for its XP drop

local tick = 0           -- ServerLogic events since load, for lap times
local pendingTick = nil  -- tick of the pending click
local lapStartTick = nil -- tick the current lap started, nil between laps

-- Menu text can carry colour tags such as "<col=00ffff>".
local function stripTags(text)
    return ((text or ""):gsub("<.->", ""))
end

local function tileDistance(coord, x, z)
    return math.max(math.abs(coord.x - x), math.abs(coord.z - z))
end

local function toCoordGrid(level, x, z)
    return CoordGrid.new(level, x // 64, z // 64, x % 64, z % 64)
end

local function getSelf()
    if not Player.IsAvailable() then return nil end
    local self = Player.GetEntity()
    if self and self.isValid then return self end
    return nil
end

-- Tiles from the player to a course's start obstacle, or nil if its spots
-- aren't recorded yet.
local function distanceToStart(data, self)
    local start = data.start and data.obstacles[data.start]
    if not start or not start.spots then return nil end
    return tileDistance(self.coordGrid, start.spots[1].x, start.spots[1].z)
end

local function routeName(r)
    for name, candidate in pairs(course.routes) do
        if candidate == r then return name end
    end
end

local function defaultRoute()
    local level = Player.GetLevelGameplay(const.AGILITY_SKILL_ID)
    local best
    for _, r in pairs(course.routes) do
        if level >= r.minLevel and (not best or r.minLevel > best.minLevel) then
            best = r
        end
    end
    return best
end

-- Lap stats --------------------------------------------------------------

-- Saved per character, so the database key starts with the display name.
-- Laps are counted per course; the fastest lap is kept per route.
local playerName = nil
local laps = 0

local function statKey(...)
    return table.concat({ playerName, ... }, "/")
end

local function showStats()
    panel.setLaps(laps)
    panel.setFastest(route and PersistentDB:GetInt(statKey(active.file, routeName(route), "fastest")))
end

local function loadStats(self)
    playerName = self.displayName
    laps = PersistentDB:GetInt(statKey(active.file, "laps")) or 0
    showStats()
end

local function completeLap()
    local ticks = tick - lapStartTick
    lapStartTick = nil
    laps = laps + 1
    PersistentDB:SetInt(statKey(active.file, "laps"), laps)

    local fastestKey = statKey(active.file, routeName(route), "fastest")
    local fastest = PersistentDB:GetInt(fastestKey)
    if not fastest or ticks < fastest then
        PersistentDB:SetInt(fastestKey, ticks)
    end
    debugLog("lap: %d done in %d ticks", laps, ticks)
    showStats()
    panel.setCurrent(nil)
end

-- Click matching -----------------------------------------------------------

-- A click counts for an obstacle when it lands within MATCH_RANGE tiles of
-- any of its spots' boxes, which also covers spots not recorded yet next to
-- recorded ones (the nets come in rows).
local function nearObstacle(o, x, z)
    local range = const.MATCH_RANGE
    for _, spot in ipairs(o.spots) do
        if x >= spot.x - range and x <= spot.x + (o.width or 1) - 1 + range
            and z >= spot.z - range and z <= spot.z + (o.length or 1) - 1 + range then
            return true
        end
    end
    return false
end

-- Finds the clicked obstacle, searching the active route first and starting
-- from the expected obstacle so duplicates (the two nets) resolve in order.
local function matchObstacle(name, verb, x, z)
    local routes = { route or defaultRoute() }
    for _, r in pairs(course.routes) do
        if r ~= routes[1] then table.insert(routes, r) end
    end

    for _, r in ipairs(routes) do
        local start = (r == route) and nextIndex or 1
        for step = 0, #r.steps - 1 do
            local i = (start - 1 + step) % #r.steps + 1
            local o = course.obstacles[r.steps[i]]
            if o.name == name and o.verb == verb and (not o.spots or nearObstacle(o, x, z)) then
                return r, i
            end
        end
    end
    return nil
end

-- Locating obstacles -------------------------------------------------------

-- The CoordGrids of each obstacle's spots, created once per load. Name-search
-- results are copied rather than holding on to the loc's.
local foundCoords = {}
local lastSearchCount = nil

local function locateObstacle(obstacle, self)
    if foundCoords[obstacle] then
        return foundCoords[obstacle]
    end
    if obstacle.spots then
        local coords = {}
        for _, spot in ipairs(obstacle.spots) do
            table.insert(coords, toCoordGrid(obstacle.level, spot.x, spot.z))
        end
        foundCoords[obstacle] = coords
        return coords
    end
    if not const.NAME_SEARCH then return nil end

    local best, bestDistance
    local locs = LocList.Filter({
        name = obstacle.name,
        coordGrid = self.coordGrid,
        range = const.SEARCH_RANGE,
        sameLevel = false,
    })
    for _, loc in ipairs(locs) do
        local c = loc.coordGrid
        local distance = tileDistance(self.coordGrid, c.x, c.z)
        if not bestDistance or distance < bestDistance then
            best, bestDistance = c, distance
        end
    end
    if best then
        foundCoords[obstacle] = { toCoordGrid(best.level, best.x, best.z) }
    end
    -- Searches repeat every tick until something is found, so only log changes.
    if #locs ~= lastSearchCount then
        debugLog("search: %q, %d results", obstacle.name, #locs)
        lastSearchCount = #locs
    end
    return foundCoords[obstacle]
end

-- Prints the footprint, rotation and 3D position of the named locs near a
-- clicked tile, for sizing an obstacle's outline. Locs merged into static
-- scenery can't be found and print nothing.
local function printLocShape(name, x, z, level)
    local locs = LocList.Filter({ name = name, coordGrid = toCoordGrid(level, x, z), range = 2 })
    if #locs == 0 then
        print("  shape: not found")
        return
    end
    for _, loc in ipairs(locs) do
        local c, p = loc.coordGrid, loc.position
        print(string.format("  shape: id %d at %d, %d, level %d, width = %d, length = %d, rotation = %s, type = %s, position = %.0f, %.0f, %.0f",
            loc.configID, c.x, c.z, c.level, loc.width, loc.length, tostring(loc.rotationType), tostring(loc.shapeType), p.x, p.y, p.z))
    end
end

-- Highlight shapes ---------------------------------------------------------

-- Wireframe box covering width x length tiles from the outline's tile (the
-- obstacle's south-west corner), height in fine units. A height of 0 draws
-- just the flat outline on the ground.
local function makeBox(width, length, height)
    local half = const.TILE_SIZE // 2 -- the outline is placed at the centre of its tile
    local x0, x1 = -half, width * const.TILE_SIZE - half
    local z0, z1 = -half, length * const.TILE_SIZE - half
    local positions = {
        Vector3.new(x0, 0, z0), Vector3.new(x1, 0, z0),
        Vector3.new(x1, 0, z1), Vector3.new(x0, 0, z1),
    }
    local lines = { 0, 1, 1, 2, 2, 3, 3, 0 } -- bottom
    if height > 0 then
        table.insert(positions, Vector3.new(x0, height, z0))
        table.insert(positions, Vector3.new(x1, height, z0))
        table.insert(positions, Vector3.new(x1, height, z1))
        table.insert(positions, Vector3.new(x0, height, z1))
        for _, i in ipairs({
            4, 5, 5, 6, 6, 7, 7, 4, -- top
            0, 4, 1, 5, 2, 6, 3, 7, -- sides
        }) do
            table.insert(lines, i)
        end
    end

    local shape = ShapeData.new()
    shape.positions = positions
    shape.lines = lines
    return shape
end

-- Outline of an obstacle's own model, from models/<course>.lua. The model is
-- turned by the loc's rotation (0-3, quarter turns clockwise seen from above)
-- and centred on its width x length footprint, whose south-west tile is the
-- outline's tile.
local function makeModelShape(model, rotation, width, length)
    local offsetX = (width - 1) * const.TILE_SIZE / 2
    local offsetZ = (length - 1) * const.TILE_SIZE / 2
    local positions = {}
    for _, p in ipairs(model.positions) do
        local x, z = p[1], p[3]
        for _ = 1, rotation do
            x, z = z, -x
        end
        table.insert(positions, Vector3.new(x + offsetX, p[2], z + offsetZ))
    end

    local shape = ShapeData.new()
    shape.positions = positions
    shape.lines = model.lines
    return shape
end

-- ShapeEntity is meant for shapes fixed in one place (moving one crashed the
-- client), so each spot of each obstacle gets its own outline, placed once,
-- and only the next obstacle's outlines are visible.
local outlines = {}   -- obstacle key -> list of ShapeEntity, one per spot
local shownKey = nil  -- key of the visible obstacle

local function createOutline(name, obstacle, coord)
    local old = ShapeList.GetEntity(name)
    if old and old.isValid then old:Destroy() end

    local width, length = obstacle.width or 1, obstacle.length or 1
    local shape
    if obstacle.model then
        shape = makeModelShape(active.models[obstacle.model], obstacle.rotation or 0, width, length)
    else
        shape = makeBox(width, length, obstacle.height or const.DEFAULT_BOX_HEIGHT)
    end
    local outline = ShapeList.CreateEntity(name)
    if not outline then return nil end
    if not outline:SetShapeData(shape) then
        outline:Destroy()
        return nil
    end
    outline.ignoreDepth = true
    outline.lineWidth = obstacle.model and const.MODEL_LINE_WIDTH or const.BOX_LINE_WIDTH
    outline.colour = const.HIGHLIGHT_COLOUR
    outline.alignType = ShapeEntityAlignType.NONE
    outline.coordGrid = coord
    outline.visible = false
    debugLog("outline: created %s at %d, %d, level %d", name, coord.x, coord.z, coord.level)
    return outline
end

local function createOutlines(key, coords)
    local list = {}
    for i, coord in ipairs(coords) do
        local outline = createOutline("obstacle_" .. key .. "_" .. i, course.obstacles[key], coord)
        if outline then table.insert(list, outline) end
    end
    return list
end

local function destroyOutlines()
    for _, list in pairs(outlines) do
        for _, outline in ipairs(list) do
            if outline.isValid then outline:Destroy() end
        end
    end
    outlines, shownKey = {}, nil
end

local function setVisible(key, visible)
    for _, outline in ipairs(outlines[key]) do
        outline.visible = visible
    end
end

local function showOutline(key)
    if key == shownKey then return end
    if shownKey then setVisible(shownKey, false) end
    if key then setVisible(key, true) end
    shownKey = key
    debugLog("outline: showing %s", key or "nothing")
end

local function refreshHighlight(self)
    if not route or not self then
        showOutline(nil)
        return
    end

    local key = route.steps[nextIndex]
    if not outlines[key] then
        local coords = locateObstacle(course.obstacles[key], self)
        if coords then outlines[key] = createOutlines(key, coords) end
    end
    showOutline(outlines[key] and key or nil)
end

-- Loading courses ----------------------------------------------------------

local function loadCourse(file, self)
    active = courses[file]
    active.file = file
    course = active.data
    route, nextIndex, pendingIndex = defaultRoute(), 1, nil
    lapStartTick = nil
    loadStats(self)
    panel.setCurrent(nil)
    panel.show(true)
    debugLog("course: loaded %s", file)
end

local function unloadCourse()
    debugLog("course: unloaded %s", active.file)
    destroyOutlines()
    foundCoords = {}
    panel.show(false)
    active, course, route, pendingIndex, lapStartTick = nil, nil, nil, nil, nil
end

-- Loads the first course within LOAD_RANGE of its start, and unloads the
-- loaded one beyond UNLOAD_RANGE.
local function updateLoadedCourse(self)
    if active then
        if distanceToStart(course, self) > const.UNLOAD_RANGE then unloadCourse() end
        return
    end
    for _, file in ipairs(const.COURSES) do
        local distance = distanceToStart(courses[file].data, self)
        if distance and distance <= const.LOAD_RANGE then
            loadCourse(file, self)
            return
        end
    end
end

-- Events ---------------------------------------------------------------------

Event.MiniMenuEntrySelected.Subscribe("agilityHelperClick", function(event)
    local loc = event.entry.locData
    local self = getSelf()
    if not loc or not self then return end

    local name, verb = stripTags(event.entry.subjectText), stripTags(event.entry.verbText)
    if const.RECORD_MODE then
        print(string.format("%s/%s: x = %d, z = %d, level = %d (player at %d, %d)",
            name, verb, loc.coordGridX, loc.coordGridZ, self.coordGrid.level, self.coordGrid.x, self.coordGrid.z))
        printLocShape(name, loc.coordGridX, loc.coordGridZ, self.coordGrid.level)
    end
    if not active then return end

    local r, i = matchObstacle(name, verb, loc.coordGridX, loc.coordGridZ)
    debugLog("click: %s", r and ("matched step " .. i) or "no match")
    if r then
        if r ~= route then
            route = r
            showStats()
        end
        pendingIndex, pendingTick = i, tick
    end
end)

Event.SkillTransmit.Subscribe("agilityHelperXp", function(event)
    debugLog("xp: skill = %d, %d -> %d", event.skill, event.oldXP, event.newXP)
    -- SkillType values are plain skill IDs.
    if event.skill ~= const.AGILITY_SKILL_ID or not pendingIndex then return end
    if event.newXP <= event.oldXP then return end

    if pendingIndex == 1 then
        lapStartTick = pendingTick
    elseif pendingIndex == #route.steps and lapStartTick then
        completeLap()
    end
    nextIndex = pendingIndex % #route.steps + 1
    pendingIndex = nil
    debugLog("xp: advanced to step %d", nextIndex)
    refreshHighlight(getSelf())
end)

Event.ServerLogic.Subscribe("agilityHelperTick", function()
    tick = tick + 1
    local self = getSelf()
    if self then updateLoadedCourse(self) end
    if not active then return end

    if lapStartTick then panel.setCurrent(tick - lapStartTick) end
    refreshHighlight(self)
end)

-- A broken panel shouldn't stop the highlights, so log the error and go on
-- without it.
local ok, err = pcall(panel.create)
if not ok then
    print("Agility Helper: lap panel unavailable: " .. tostring(err))
    panel.destroy()
end

-- Called by the client when the plugin is disabled or reloaded, so a reload
-- starts without the previous load's outlines, panel and subscriptions.
-- Must be global for the client to find it.
function PluginShutdown()
    destroyOutlines()
    panel.destroy()
    Event.MiniMenuEntrySelected.Unsubscribe("agilityHelperClick")
    Event.SkillTransmit.Unsubscribe("agilityHelperXp")
    Event.ServerLogic.Unsubscribe("agilityHelperTick")
end
