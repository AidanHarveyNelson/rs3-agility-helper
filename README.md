# Agility Helper

RuneScape plugin (official Lua plugin API) that highlights the next obstacle to
click on an agility course and tracks laps. Supports Gnome Stronghold (basic
and advanced), Burthorpe and Barbarian Outpost (basic and advanced) so far.

## Running on a developer beta world

1. Link the plugin into the beta client's dev plugin folder:
   ```sh
   ln -s "$PWD" ~/Jagex/RuneScape-BETA/dev_plugins/rs3-agility-helper
   ```
2. Log into a developer world, open the console with ``Alt+` `` and run:
   ```
   prf
   pon rs3-agility-helper
   ```
3. After editing Lua files, reload with `prl rs3-agility-helper`.

Useful cheats: `!tele <level,mapSquareX,mapSquareZ,localX,localZ>`, or
Ctrl+Shift+click to teleport.

## Recording course coordinates

With `RECORD_MODE = true` in `constants.lua`, every loc click prints a line like:

```
>>Log balance/Walk-across: x = ..., z = ..., level = 0
```

Copy the values into the matching obstacle in `courses/gnome_stronghold.lua`
as a spot (e.g. `level = 0, spots = { { x = ..., z = ... } }`). Obstacles you
can take at several places (the three nets in a row, the two pipes) list one
spot per place. Recorded spots make the highlight exact, let the two sets of
obstacle nets be told apart, and start the course automatically near the
first obstacle.

## Before submitting

- Set a real `contactEmailAddress` in `plugin.json` (not your mod.io email).
- Set `RECORD_MODE = false` and `DEBUG = false` in `constants.lua`.
- Highlighting guidance falls under "subject to review" in the plugin
  guidelines; check on the Plugin Portal Discord first.

## Todo

Setup
- [x] Model capture: extract obstacle models from the cache with rsmv and turn
  them into outlines (`tools/`)

Courses
- [x] Gnome Stronghold
- [x] Burthorpe
- [x] Barbarian Outpost
- [ ] Wilderness (recorded, needs testing)
- [ ] Werewolf (recorded up to the zip line; still needs the stick and the
  Agility Trainer)
- [ ] Agility Pyramid
- [ ] Penguin
- [ ] Ape Atoll
- [ ] Bandos's Throne Room
- [ ] Het's Oasis
- [ ] Hefin
- [ ] Dorgesh-Kaan
- [ ] Anachronia

UI
- [x] Add the lap panel (laps, current lap time, fastest lap time)
- [ ] Improve the UI: make the panel draggable, and add settings (highlight
  on/off, colour)

Other
- [ ] Handle falling off an obstacle: highlight the way back (e.g. the
  Wilderness pit ladder) and return to the failed obstacle
- [ ] Steps that give no XP (e.g. taking the stick on the Werewolf course)
- [ ] Courses that aren't a simple loop (Agility Pyramid levels, Anachronia
  sections)
- [ ] Simplify busy model outlines (cliffside, spring device, walls)
- [ ] Possibly preview the obstacle after next
