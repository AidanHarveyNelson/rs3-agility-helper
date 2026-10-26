-- Gnome Stronghold Agility Course.
--
-- Obstacle names and verbs come from the RuneScape Wiki. Spots (x, z) and
-- level were recorded with RECORD_MODE in main.lua; level is the player's
-- level when clicking. An obstacle with several spots (the three nets in a
-- row, the two pipes) is highlighted at all of them, and clicking any one
-- counts. Obstacles without spots are not highlighted.
-- width and length are the loc's footprint in tiles (after rotation), as
-- printed by the shape: lines in RECORD_MODE, along with ids (the loc config
-- IDs) and rotation (quarter turns, 0-3).
-- model draws the outline of that model from models/gnome_stronghold.lua (see
-- tools/README.md). Without one, a box is drawn over the footprint, height
-- fine units tall (512 per tile, default 512); a height of 0 draws a flat
-- tile outline instead.
return {
    name = "Gnome Stronghold",

    obstacles = {
        log_balance = {
            name = "Log balance", verb = "Walk-across", level = 0, height = 0, ids = { 69526 },
            spots = { { x = 2474, z = 3435 } },
        },
        net_1 = {
            name = "Obstacle net", verb = "Climb-over", level = 0, width = 2, ids = { 69383 },
            model = 68177, rotation = 0,
            spots = { { x = 2471, z = 3425 }, { x = 2473, z = 3425 }, { x = 2475, z = 3425 } },
        },
        branch_up = {
            name = "Tree branch", verb = "Climb", level = 1, length = 2, ids = { 69508 },
            model = 68103, rotation = 0,
            spots = { { x = 2473, z = 3421 } },
        },
        rope = {
            name = "Balancing rope", verb = "Walk-on", level = 2, height = 0, ids = { 2312, 4059 },
            spots = { { x = 2478, z = 3420 } },
        },
        branch_down = {
            name = "Tree branch", verb = "Climb-down", level = 2, ids = { 69507 },
            model = 68104, rotation = 0,
            spots = { { x = 2487, z = 3420 } },
        },
        net_2 = {
            name = "Obstacle net", verb = "Climb-over", level = 0, width = 2, ids = { 69384 },
            model = 68177, rotation = 2,
            spots = { { x = 2483, z = 3426 }, { x = 2485, z = 3426 }, { x = 2487, z = 3426 } },
        },
        pipe = {
            -- Only the 2483 pipe's rotation was printed; 2487 is assumed to match.
            name = "Obstacle pipe", verb = "Squeeze-through", level = 0, length = 2, ids = { 69378 },
            model = 68171, rotation = 2,
            spots = { { x = 2483, z = 3431 }, { x = 2487, z = 3431 } },
        },

        -- Advanced course (85 Agility), branching off after the first tree branch.
        tree = {
            name = "Tree", verb = "Climb-up", level = 2, ids = { 69506 },
            model = 68117, rotation = 0,
            spots = { { x = 2472, z = 3419 } },
        },
        signpost = {
            name = "Signpost", verb = "Run-across", level = 3, ids = { 69514 },
            model = 68007, rotation = 1,
            spots = { { x = 2478, z = 3417 } },
        },
        pole = {
            -- Five pole locs, one per tile, make up the bar.
            name = "Pole", verb = "Swing-to", level = 3, ids = { 43529 },
            model = 47321, rotation = 0,
            spots = {
                { x = 2484, z = 3425 }, { x = 2485, z = 3425 }, { x = 2486, z = 3425 },
                { x = 2487, z = 3425 }, { x = 2488, z = 3425 },
            },
        },
        barrier = {
            name = "Barrier", verb = "Jump-over", level = 3, ids = { 69389 },
            model = 68178, rotation = 1,
            spots = { { x = 2485, z = 3433 } },
        },
    },

    -- When the course starts, the route with the highest minLevel the player
    -- meets is chosen. Clicking another route's obstacle switches to it.
    routes = {
        basic = {
            minLevel = 1,
            steps = { "log_balance", "net_1", "branch_up", "rope", "branch_down", "net_2", "pipe" },
        },
        advanced = {
            minLevel = 85,
            steps = { "log_balance", "net_1", "branch_up", "tree", "signpost", "pole", "barrier" },
        },
    },

    -- The course starts within activateRange tiles of the start obstacle's
    -- first spot and stops beyond deactivateRange.
    start = "log_balance",
    activateRange = 10,
    deactivateRange = 100,
}
