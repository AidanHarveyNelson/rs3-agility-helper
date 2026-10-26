-- Barbarian Outpost Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Barbarian_Outpost_Agility_Course
-- Location: Barbarian Outpost, northern Kandarin
-- Level requirement: 35 Agility (advanced route: 90 Agility); requires Bar Crawl
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Rope swing / Swing-on
--   2. Log balance / Walk-across
--   3. Obstacle net / Climb-over
--   4. Balancing ledge / Walk-across
--   5. Ladder / Climb-down
--   6. Crumbling wall / Climb-over
--   7. Crumbling wall / Climb-over (second wall)
-- Note: Advanced route (90 Agility) is part of this course: Rope swing (Swing-on), Log balance (Walk-across), then Wall (Run-up), Wall (Climb-up), Spring device (Fire), Balance beam (Cross), Gap (Jump-over), Roof (Slide-down).
-- Note: Wiki gives actions as prose; verbs above are inferred from the wording.
return {
    name = "Barbarian Outpost",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
}
