# Obstacle model outlines

`models/<course>.lua` holds outlines of a course's obstacle models, generated
from the game cache; `courses/<course>.lua` holds the course data that refers
to them. The plugin can't read the cache itself, so the outlines are made
ahead of time with these steps.

## 1. Find the loc and model IDs

With `RECORD_MODE = true`, clicking an obstacle prints `shape:` lines with the
loc's config ID, footprint and rotation. Put the ID in the obstacle's `ids`.

## 2. Extract with rsmv

[rsmv](https://github.com/skillbert/rsmv) decodes the NXT cache. It needs
Node.js 26 or newer (it uses `Map.getOrInsertComputed`). Set it up once:

```sh
git clone https://github.com/skillbert/rsmv.git
cd rsmv
npm install --ignore-scripts
npm rebuild sqlite3 lzma-native
npx webpack
```

Then, from the rsmv folder:

```sh
# loc configs: each lists its model under "models"
node dist/cli extract -o "cache:C:/ProgramData/Jagex/RuneScape-BETA" -s out/locs --mode locs -i 69508,69507

# the models themselves
node dist/cli extract -o "cache:C:/ProgramData/Jagex/RuneScape-BETA" -s out/models --mode models -i 68103,68104
```

After upgrading Node.js, run `npm rebuild sqlite3 lzma-native` again.

## 3. Convert to outlines

```sh
python tools/model_to_shape.py <rsmv>/out/models gnome_stronghold 68103 68104 ...
```

This regenerates `models/gnome_stronghold.lua` with every model listed, so
list them all. Then set `model` and `rotation` on the obstacle in
`courses/gnome_stronghold.lua`.

rsmv's readme asks that leaked or unreleased content found with it is not
shared publicly.
