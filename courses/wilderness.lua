-- Wilderness Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Wilderness_Agility_Course
-- Location: Wilderness, levels 50-53 (PvP enabled)
-- Level requirement: 52 Agility to enter (49 for the first obstacle)
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Obstacle pipe / Squeeze-through
--   2. Ropeswing / Swing-on
--   3. Stepping stone / Cross
--   4. Log balance / Walk-across
--   5. Cliffside / Climb
return {
    name = "Wilderness",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
