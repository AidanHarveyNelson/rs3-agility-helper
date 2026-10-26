# Agility Helper

RuneScape plugin (official Lua plugin API) that highlights the next obstacle to
click on an agility course. Supports the Gnome Stronghold course (basic and
advanced) for now.

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
