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

With `RECORD_MODE = true` in `main.lua`, every loc click prints a line like:

```
>>Log balance/Walk-across: x = ..., z = ..., level = 0
```

Copy the values into the matching obstacle in `courses/gnome_stronghold.lua`
(e.g. `{ name = "Log balance", verb = "Walk-across", x = ..., z = ..., level = 0 }`).
Recorded coordinates make the highlight exact, let the two obstacle nets be
told apart, and start the course automatically near the first obstacle.

## Before submitting

- Set a real `contactEmailAddress` in `plugin.json` (not your mod.io email).
- Set `RECORD_MODE = false`.
- Highlighting guidance falls under "subject to review" in the plugin
  guidelines; check on the Plugin Portal Discord first.
