-- Burthorpe Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Burthorpe_Agility_Course
-- Location: Northeastern Burthorpe, Asgarnia (starts at Drill Sergeant Hartman)
-- Level requirement: 1 Agility
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Log beam / Walk
--   2. Wall / Climb-up
--   3. Balancing ledge / Walk-across
--   4. Obstacle low wall / Climb-over
--   5. Rope swing / Swing-on
--   6. Monkey bars / Swing-across
--   7. Ledge / Jump-down
-- Note: No advanced route listed.
return {
    name = "Burthorpe",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
