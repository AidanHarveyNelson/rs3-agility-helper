-- Hefin Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Hefin_Agility_Course
-- Location: Hefin Clan district, Prifddinas (Tirannwn)
-- Level requirement: 77 Agility (cannot be boosted); requires Plague's End
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Leap across walkway / Leap
--   2. Traverse cliff / Traverse
--   3. Scale cathedral / Scale
--   4. Vault roof / Vault
--   5. Slide down zip-line / Slide
--   6. Merge with Light creature / Merge
return {
    name = "Hefin",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
