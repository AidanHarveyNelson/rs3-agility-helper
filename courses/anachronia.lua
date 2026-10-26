-- Anachronia Agility Course (stub).
-- Wiki: https://runescape.wiki/w/Anachronia_Agility_Course
-- Location: Anachronia (Equilibrium League region; Anachronia lodestone)
-- Level requirement: 30-85 Agility depending on section (A/G 30, B/F 50, C/E 70, D 85; full lap 85)
--
-- Empty placeholder: fill obstacles/routes by recording with RECORD_MODE (see
-- courses/gnome_stronghold.lua for the structure). Do not guess ids or spots.
--
-- Obstacles on the wiki, in lap order (name / action):
--   1. Section A (30) / Cliff face: Traverse; Cliff face: Traverse; Ruined temple: Traverse; Ruined temple: Traverse; Cave entrance: Enter; Roots: Cross
--   2. Section B (50) / Ruined temple: Traverse; Ruined temple: Jump across; Ruined temple: Traverse; Ruined temple: Climb; Ruined temple: Jump across; Bones: Traverse; Spine: Cross; Bones: Traverse
--   3. Section C (70) / Cliff face: Traverse; Ruined temple: Traverse; Ruined temple: Traverse; Temple balance: Traverse; Ruined temple: Traverse; Roots: Traverse; Vines: Cross; Vines: Cross
--   4. Section D (85) / Vines: Cross; Roots: Climb over; Sunken column: Jump across; Big block: Climb over; Roots: Jump across; Roots: Traverse; Vines: Cross; Vines: Cross
--   5. Section E (70) / Block: Climb over; Ruins: Traverse; Vines: Cross; Bones: Climb over; Rock: Traverse; Root: Traverse; Vines: Cross; Vines: Cross
--   6. Section F (50) / Ruins: Traverse; Ruins: Jump across; Plank: Cross; Ruined temple: Traverse; Ruined column: Traverse; Cliff face: Traverse
--   7. Section G (30) / Tree: Jump across; Cliff face: Traverse; Vines: Cross; Root: Climb over; Vines: Cross; Cliff face: Traverse; Cliff face: Traverse; Temple wall: Traverse
-- Note: Lap runs A to G; wiki does not give one continuous order, section transitions are inferred.
return {
    name = "Anachronia",

    obstacles = {
        -- (empty)
    },

    routes = {},
    start = nil,
}
