-- Burthorpe Agility Course.
-- Wiki: https://runescape.wiki/w/Burthorpe_Agility_Course
-- Location: Northeastern Burthorpe, Asgarnia (starts at Drill Sergeant Hartman)
-- Level requirement: 1 Agility
--
-- Spots, levels, ids, footprints and rotations were recorded with RECORD_MODE;
-- see courses/gnome_stronghold.lua for what each field means. Models are in
-- models/burthorpe.lua.
return {
    name = "Burthorpe",

    obstacles = {
        log_beam = {
            name = "Log beam", verb = "Walk", level = 0, width = 5, ids = { 66894 },
            model = 32648, rotation = 2,
            spots = { { x = 2917, z = 3578 } },
        },
        wall = {
            name = "Wall", verb = "Climb-up", level = 0, ids = { 66912 },
            model = 44314, rotation = 0,
            spots = { { x = 2913, z = 3578 } },
        },
        ledge_balance = {
            -- Three pieces in a row; 3573 is the middle piece (id 3562).
            name = "Balancing ledge", verb = "Walk-across", level = 1, ids = { 66909, 3562 },
            model = 3631, rotation = 2,
            spots = { { x = 2910, z = 3572 }, { x = 2910, z = 3573 }, { x = 2910, z = 3574 } },
        },
        low_wall = {
            name = "Obstacle low wall", verb = "Climb-over", level = 1, width = 3, ids = { 66902 },
            model = 32625, rotation = 0,
            spots = { { x = 2911, z = 3570 } },
        },
        rope_swing = {
            name = "Rope swing", verb = "Swing-on", level = 1, ids = { 66904 },
            model = 53111, rotation = 2,
            spots = { { x = 2912, z = 3573 } },
        },
        monkey_bars = {
            name = "Monkey bars", verb = "Swing-across", level = 1, length = 2, ids = { 66897 },
            model = 32624, rotation = 1,
            spots = { { x = 2914, z = 3575 } },
        },
        ledge_jump = {
            -- A level 0 loc with the same id and rotation 3 sits under this one.
            name = "Ledge", verb = "Jump-down", level = 1, ids = { 66910 },
            model = 32621, rotation = 1,
            spots = { { x = 2921, z = 3575 } },
        },
    },

    routes = {
        basic = {
            minLevel = 1,
            steps = { "log_beam", "wall", "ledge_balance", "low_wall", "rope_swing", "monkey_bars", "ledge_jump" },
        },
    },

    -- The course loads near this obstacle's first spot (see LOAD_RANGE in
    -- constants.lua).
    start = "log_beam",
}
