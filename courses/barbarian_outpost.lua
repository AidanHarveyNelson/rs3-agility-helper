-- Barbarian Outpost Agility Course.
-- Wiki: https://runescape.wiki/w/Barbarian_Outpost_Agility_Course
-- Location: Barbarian Outpost, northern Kandarin
-- Level requirement: 35 Agility (advanced route: 90 Agility); requires Bar Crawl
--
-- Spots, levels, ids, footprints and rotations were recorded with RECORD_MODE;
-- see courses/gnome_stronghold.lua for what each field means. Models are in
-- models/barbarian_outpost.lua. Some verbs here have no hyphen ("Climb over");
-- they are copied from the cache.
--
-- The obstacle pipe (Squeeze through, 2552, 3559, id 20210) only lets you into
-- the course, so it isn't part of the lap.
--
-- The advanced route (90 Agility) shares the rope swing and log balance, then
-- goes up the wall and across the rooftops.
return {
    name = "Barbarian Outpost",

    obstacles = {
        rope_swing = {
            -- Two ropes side by side.
            name = "Rope swing", verb = "Swing-on", level = 0, length = 6, ids = { 43526 },
            model = 2269, rotation = 0,
            spots = { { x = 2551, z = 3550 }, { x = 2552, z = 3550 } },
        },
        log_balance = {
            name = "Log balance", verb = "Walk-across", level = 0, ids = { 43595 },
            model = 47309, rotation = 3,
            spots = { { x = 2550, z = 3546 } },
        },
        net = {
            name = "Obstacle net", verb = "Climb over", level = 0, length = 2, ids = { 20211 },
            model = 20636, rotation = 3,
            spots = { { x = 2538, z = 3545 } },
        },
        ledge = {
            name = "Balancing ledge", verb = "Walk-across", level = 1, ids = { 2302 },
            model = 1072, rotation = 1,
            spots = { { x = 2535, z = 3547 } },
        },
        ladder = {
            -- The level 0 end is a separate loc (1747, Climb up).
            name = "Ladder", verb = "Climb down", level = 1, ids = { 3205 },
            model = 9504, rotation = 2,
            spots = { { x = 2532, z = 3545 } },
        },
        wall_1 = {
            name = "Crumbling wall", verb = "Climb-over", level = 0, ids = { 1948 },
            model = 47311, rotation = 2,
            spots = { { x = 2537, z = 3553 } },
        },
        wall_2 = {
            name = "Crumbling wall", verb = "Climb-over", level = 0, ids = { 1948 },
            model = 47311, rotation = 2,
            spots = { { x = 2542, z = 3553 } },
        },

        -- Advanced route (90 Agility).
        wall_run = {
            name = "Wall", verb = "Run-up", level = 0, ids = { 43533 },
            model = 47312, rotation = 2,
            spots = { { x = 2538, z = 3541 } },
        },
        wall_climb = {
            name = "Wall", verb = "Climb-up", level = 2, ids = { 43597 },
            model = 47338, rotation = 0,
            spots = { { x = 2537, z = 3546 } },
        },
        spring = {
            name = "Spring device", verb = "Fire", level = 3, width = 3, length = 3, ids = { 43587 },
            model = 47314, rotation = 2,
            spots = { { x = 2532, z = 3544 } },
        },
        beam = {
            name = "Balance beam", verb = "Cross", level = 3, ids = { 43527 },
            model = 47293, rotation = 0,
            spots = { { x = 2534, z = 3553 } },
        },
        gap = {
            name = "Gap", verb = "Jump-over", level = 3, ids = { 43531 },
            model = 10772, rotation = 1,
            spots = { { x = 2537, z = 3553 } },
        },
        roof = {
            -- Three pieces in a row.
            name = "Roof", verb = "Slide-down", level = 2, ids = { 43532 },
            model = 121926, rotation = 3,
            spots = { { x = 2540, z = 3552 }, { x = 2540, z = 3553 }, { x = 2540, z = 3554 } },
        },
    },

    routes = {
        basic = {
            minLevel = 35,
            steps = { "rope_swing", "log_balance", "net", "ledge", "ladder", "wall_1", "wall_2" },
        },
        advanced = {
            minLevel = 90,
            steps = { "rope_swing", "log_balance", "wall_run", "wall_climb", "spring", "beam", "gap", "roof" },
        },
    },

    -- The course loads near this obstacle's first spot (see LOAD_RANGE in
    -- constants.lua).
    start = "rope_swing",
}
