-- Gnome Stronghold Agility Course.
--
-- Obstacle names and verbs come from the RuneScape Wiki. Coordinates (x, z,
-- level) are not recorded yet: turn on RECORD_MODE in main.lua, run a lap, and
-- paste the printed values into each obstacle. Until then the highlighter
-- falls back to the nearest loc with a matching name.
return {
    name = "Gnome Stronghold",

    obstacles = {
        log_balance = { name = "Log balance",    verb = "Walk-across" },
        net_1       = { name = "Obstacle net",   verb = "Climb-over" },
        branch_up   = { name = "Tree branch",    verb = "Climb" },
        rope        = { name = "Balancing rope", verb = "Walk-on" },
        branch_down = { name = "Tree branch",    verb = "Climb-down" },
        net_2       = { name = "Obstacle net",   verb = "Climb-over" },
        pipe        = { name = "Obstacle pipe",  verb = "Squeeze-through" },

        -- Advanced course (85 Agility), branching off after the first tree branch.
        tree        = { name = "Tree",           verb = "Climb-up" },
        signpost    = { name = "Signpost",       verb = "Run-across" },
        pole        = { name = "Pole",           verb = "Swing-to" },
        barrier     = { name = "Barrier",        verb = "Jump-over" },
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

    -- The course starts within activateRange tiles of the start obstacle and
    -- stops beyond deactivateRange. Needs the start obstacle's coords recorded.
    start = "log_balance",
    activateRange = 10,
    deactivateRange = 100,
}
