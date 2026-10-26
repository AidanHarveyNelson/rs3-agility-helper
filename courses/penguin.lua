-- Penguin Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Penguin_Agility_Course
-- Location: The Iceberg (inside the penguin outpost behind the avalanche)
-- Level requirement: 30 Agility; requires part of Cold War and the penguin/clockwork suit
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Crusher / Walk past
--   2. Stepping stone / Climb
--   3. Stepping stone / Jump (seven times)
--   4. Icicles / Tread-softly (four times)
--   5. Ice / Cross (multiple times)
--   6. Ice slope / no interaction (cutscene)
--   7. Gate / Open
return {
    name = "Penguin",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
