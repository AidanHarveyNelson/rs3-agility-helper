-- Werewolf Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Werewolf_Agility_Course
-- Location: Haunted Woods, south-east of Canifis, Morytania
-- Level requirement: 60 Agility; requires Creature of Fenkenstrain (ring of charos)
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Stepping stones / Jump-to
--   2. Hurdles / Jump
--   3. Pipe / Squeeze-through
--   4. Stick / Take
--   5. Skull slope / Climb-up
--   6. Zip line / Teeth-grip
--   7. Agility Trainer / Give-stick
-- Note: Wiki does not give exact menu text; verbs are the page's wording.
return {
    name = "Werewolf",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
    activateRange = 10,
    deactivateRange = 100,
}
