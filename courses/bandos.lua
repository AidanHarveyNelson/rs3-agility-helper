-- Bandos's Throne Room Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Bandos%27s_Throne_Room_Agility_Course
-- Location: Bandos's throne room, Yu'biusk
-- Level requirement: 60 Agility, 60 Ranged, 60 Strength; requires The Chosen Commander, crossbow and grapple
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Goblin statue / Climb-on
--   2. Ork statue / Jump-to
--   3. Ogre statue / Jump-to
--   4. Ork statue / Jump-to
--   5. Ogre statue / Jump-to
--   6. Ourg statue (holding the bowl) / Jump-to
--   7. Ogre statue / Jump-to
--   8. Ork statue / Jump-to
--   9. Ogre statue / Jump-to
--   10. Ledge / Jump-to
--   11. Spear / Grapple
--   12. Throne / Jump-down
return {
    name = "Bandos's Throne Room",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
