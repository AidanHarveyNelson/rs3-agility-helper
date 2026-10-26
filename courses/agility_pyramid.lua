-- Agility Pyramid Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Agility_Pyramid
-- Location: Kharidian Desert, between Sophanem and Nardah
-- Level requirement: 30 Agility
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Level 1 / Stairs, Stone block, Low wall, Ledge, Pyramid block, Plank, Stone block, Gap (cross), Ledge, Stairs
--   2. Level 2 / Gap (cross), Gap (jump), Gap (cross), Stone block, Ledge, Low wall, Gap (jump), Stairs
--   3. Level 3 / Low wall, Ledge, Pyramid block, Gap (jump), Plank, Stairs
--   4. Level 4 / Gap (jump), Low wall, Stone block, Gap (jump), Low wall, Stairs
--   5. Level 5 / Climbing rocks, Stone block, Gap (jump), Doorway
-- Note: Wiki lists obstacle names per pyramid level only; exact actions are not given (only cross / jump for gaps).
return {
    name = "Agility Pyramid",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
