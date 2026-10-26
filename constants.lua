-- Settings and fixed values shared by the plugin's files.
return {
    -- Print every loc click as "name/verb: x, z, level" plus its shape: lines,
    -- for filling in course data. Set false before submitting.
    RECORD_MODE = true,

    -- Print progress (outlines, XP, clicks) to the console. Set false
    -- before submitting.
    DEBUG = true,

    -- Highlight obstacles without recorded spots at the nearest loc with a
    -- matching name. Off while recorded spots cover the course.
    NAME_SEARCH = false,

    -- Courses to load, as file names in courses/ and models/. A course loads
    -- within LOAD_RANGE tiles of its start obstacle and unloads (highlights
    -- removed) beyond UNLOAD_RANGE; the gap stops it flickering at the edge.
    -- Courses whose start isn't recorded yet are skipped.
    COURSES = {
        "gnome_stronghold", "burthorpe", "agility_pyramid", "penguin",
        "barbarian_outpost", "ape_atoll", "wilderness", "werewolf", "bandos",
        "hets_oasis", "hefin", "dorgesh_kaan", "anachronia",
    },
    LOAD_RANGE = 50,
    UNLOAD_RANGE = 75,

    AGILITY_SKILL_ID = 16,

    -- Highlights
    HIGHLIGHT_COLOUR = 0x00FF00FF, -- RGBA
    BOX_LINE_WIDTH = 4,
    MODEL_LINE_WIDTH = 2, -- model outlines have many more lines than boxes
    TILE_SIZE = 512, -- fine units per tile
    DEFAULT_BOX_HEIGHT = 512, -- fine units, for obstacles without a model or height
    SEARCH_RANGE = 30, -- tiles to search for an obstacle with no recorded spots
    MATCH_RANGE = 2, -- tiles around a recorded spot that still match a click
}
