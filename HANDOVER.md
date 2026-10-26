# Handover: rs3-agility-helper

## Goal
A RuneScape 3 plugin that highlights the next obstacle to click on an agility
course. It starts with Gnome Stronghold (basic and advanced routes), and more
courses come later as extra data files in `courses/`.

## Background
- The project started as "plank box contents in bank presets" and was dropped.
  The plugin API can't move items or send actions, and Jagex's guidelines ban
  automation and menu entries that send actions to the server.
- The folder was renamed from `rs3-better-loadouts` to `rs3-agility-helper`.

## Platform: official RS3 plugin API
- Launched 19 Oct 2026. Plugins are Lua 5.4.8. Docs: https://developer.runescape.com/rs/index.html
- A plugin is `main.lua` + `plugin.json` (+ optional `resources/`). `require("path/no_ext")` is relative to the plugin root.
- Developer worlds: plugins go in `~/Jagex/RuneScape-BETA/dev_plugins/<folder>` on Mac. In the console (`Alt+\``): `prf`, `plist`, `pon <folder>`, `prl <folder>`, `poff <folder>`.
  Cheats: `!tele level,msX,msZ,localX,localZ`, Ctrl+Shift+click to teleport, `!give`, `!setvar`.
- Published via mod.io after Jagex QA review. Guideline status: obstacle guidance and
  menu customisation are "subject to review". Automation, sending inputs and revealing
  hidden info are prohibited. AI-assisted code must be readable and understood by the author.
  Ask on the Plugin Portal Discord (rs.game/RS-Plugin-Discord) before submitting.
- API details used here:
  - `Event.X.Subscribe("name", fn)` / `Event.X.Unsubscribe("name")`
  - `Event.MiniMenuEntrySelected`: `event.entry.verbText`, `.subjectText`, `.locData` (`coordGridX`, `coordGridZ`, `config`; there is no entity field)
  - `Event.SkillTransmit`: `skill` (SkillType), `oldXP`, `newXP`, `oldGameplayLevel`, `newGameplayLevel`
  - `Event.ServerLogic` fires about every 600 ms. `Player.IsAvailable()`, `Player.GetEntity()` → `.coordGrid`, `.position`, `.isValid`
  - `Player.GetLevelGameplay(SkillType)`, `SkillType.FromID(id)`
  - `CoordGrid.new(level, msX, msZ, localX, localZ)`; properties `x`, `z`, `level` (world tiles; 64 tiles per map square)
  - `LocList.Filter{ name, coordGrid, range, sameLevel }` → LocEntity (`coordGrid`, `config`, `displayName`).
    Inactive locs are merged into static scenery and may NOT be returned.
  - `ShapeList.CreateEntity/GetEntity(name)` → ShapeEntity (`SetShapeData`, `coordGrid`, `visible`,
    `ignoreDepth`, `lineWidth`, `colour` (RGBA, alpha in the low byte), `alignType`, `heightOffset`). Tiles are 512 fine units wide.
  - Inventory, var and mouse APIs are read-only.

## Current state (v0.1.0, syntax-checked with luac, not yet run in game)
- `plugin.json`: `contactEmailAddress` is a TODO placeholder.
- `courses/gnome_stronghold.lua`: obstacles (name and verb from the wiki), `routes.basic` and
  `routes.advanced` (each with `minLevel` and `steps`; advanced needs 85 and branches after `branch_up`),
  plus `start`, `activateRange` and `deactivateRange`. main.lua holds no course-specific values.
  No coordinates recorded yet.
- `main.lua`:
  - A click on a course obstacle sets it as pending. The next Agility XP gain advances to the following obstacle.
    The lap bonus is ignored because nothing is pending.
  - Matching searches the active route first, starting at the expected index, so the duplicate nets resolve in order.
    Recorded x/z values also disambiguate.
  - A green tile outline (ShapeEntity "nextObstacle") marks the next obstacle. Without coordinates it falls back to
    the nearest loc found by name within 30 tiles.
  - With recorded coordinates it activates within 10 tiles of the log balance and deactivates beyond 100.
  - `RECORD_MODE = true` prints `name/verb: x, z, level` for every loc click.

## Unverified assumptions (check first on a dev world)
1. `event.skill.id` exists and Agility's ID is 16.
2. Gnome course obstacles are found by `LocList.Filter` by name.
3. Menu `verbText` and `subjectText` match the wiki strings once colour tags are stripped.
4. The highlight renders at the right place and height (`alignType` OBJECT, `ignoreDepth` true).

## Next steps
1. Load on a dev world and run a lap with RECORD_MODE on.
2. Paste the recorded coordinates into `courses/gnome_stronghold.lua` and fix any wrong assumptions above.
3. Size the highlight per obstacle (the nets are multi-tile) and possibly preview the obstacle after next.
4. Add a settings UI (toggle, colour) and more courses.
5. Before submitting: real contact email, RECORD_MODE off, ask on the Discord.
