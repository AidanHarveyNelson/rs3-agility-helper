-- Agility Helper: highlights the next obstacle to click on an agility course.
--
-- Progress is tracked in two steps so misclicks don't advance the course:
--   1. Clicking a course obstacle marks it as pending.
--   2. The next Agility XP gain confirms it and moves the highlight on.
-- The lap-completion bonus arrives with nothing pending, so it is ignored.

local course = require("courses/gnome_stronghold")

-- Print every loc click as "name/verb: x, z, level" for filling in course data.
local RECORD_MODE = true

local AGILITY_SKILL_ID = 16
local HIGHLIGHT_COLOUR = 0x00FF00FF
local SEARCH_RANGE = 30 -- tiles to search for an obstacle with no recorded coords

local agility = SkillType.FromID(AGILITY_SKILL_ID)

local route = nil        -- active route from the course file, nil when off-course
local nextIndex = 1      -- position in route of the obstacle to highlight
local pendingIndex = nil -- clicked obstacle waiting for its XP drop

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

local function defaultRoute()
    local level = Player.GetLevelGameplay(agility)
    local best
    for _, r in pairs(course.routes) do
        if level >= r.minLevel and (not best or r.minLevel > best.minLevel) then
            best = r
        end
    end
    return best
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
            if o.name == name and o.verb == verb and (not o.x or (o.x == x and o.z == z)) then
                return r, i
            end
        end
    end
    return nil
end

local function locateObstacle(obstacle, self)
    if obstacle.x then
        return toCoordGrid(obstacle.level, obstacle.x, obstacle.z)
    end

    local best, bestDistance
    local locs = LocList.Filter({
        name = obstacle.name,
        coordGrid = self.coordGrid,
        range = SEARCH_RANGE,
        sameLevel = false,
    })
    for _, loc in ipairs(locs) do
        local distance = tileDistance(self.coordGrid, loc.coordGrid.x, loc.coordGrid.z)
        if not bestDistance or distance < bestDistance then
            best, bestDistance = loc.coordGrid, distance
        end
    end
    return best
end

local function makeTileOutline()
    local half = 256 -- a tile is 512 fine units wide
    local shape = ShapeData.new()
    shape.positions = {
        Vector3.new(-half, 0, -half), Vector3.new(half, 0, -half),
        Vector3.new(half, 0, half), Vector3.new(-half, 0, half),
    }
    shape.lines = { 0, 1, 1, 2, 2, 3, 3, 0 }
    return shape
end

local highlight = ShapeList.GetEntity("nextObstacle") or ShapeList.CreateEntity("nextObstacle")
highlight:SetShapeData(makeTileOutline())
highlight.ignoreDepth = true
highlight.lineWidth = 4
highlight.colour = HIGHLIGHT_COLOUR
highlight.alignType = ShapeEntityAlignType.OBJECT
highlight.visible = false

local function refreshHighlight(self)
    local coord = route and self and locateObstacle(course.obstacles[route.steps[nextIndex]], self)
    if coord then highlight.coordGrid = coord end
    highlight.visible = coord ~= nil
end

-- Starts the course near the first obstacle and stops it after leaving the
-- area. Only works once the first obstacle's coords are recorded; otherwise
-- the course starts on the first obstacle click.
local function updateActivation(self)
    local start = course.obstacles[course.start]
    if not start.x then return end

    local distance = tileDistance(self.coordGrid, start.x, start.z)
    if not route and distance <= course.activateRange then
        route, nextIndex, pendingIndex = defaultRoute(), 1, nil
    elseif route and distance > course.deactivateRange then
        route, pendingIndex = nil, nil
    end
end

Event.MiniMenuEntrySelected.Subscribe("agilityHelperClick", function(event)
    local loc = event.entry.locData
    local self = getSelf()
    if not loc or not self then return end

    local name, verb = stripTags(event.entry.subjectText), stripTags(event.entry.verbText)
    if RECORD_MODE then
        print(string.format("%s/%s: x = %d, z = %d, level = %d",
            name, verb, loc.coordGridX, loc.coordGridZ, self.coordGrid.level))
    end

    local r, i = matchObstacle(name, verb, loc.coordGridX, loc.coordGridZ)
    if r then
        route, pendingIndex = r, i
    end
end)

Event.SkillTransmit.Subscribe("agilityHelperXp", function(event)
    if RECORD_MODE then
        print(string.format("xp: skill = %s, %d -> %d",
            tostring(event.skill and event.skill.id), event.oldXP, event.newXP))
    end
    if event.skill.id ~= AGILITY_SKILL_ID or not pendingIndex then return end
    if event.newXP <= event.oldXP then return end

    nextIndex = pendingIndex % #route.steps + 1
    pendingIndex = nil
    refreshHighlight(getSelf())
end)

-- Re-checked every server tick because locs found by name only exist once
-- they are loaded near the player.
Event.ServerLogic.Subscribe("agilityHelperTick", function()
    local self = getSelf()
    if self then updateActivation(self) end
    refreshHighlight(self)
end)
