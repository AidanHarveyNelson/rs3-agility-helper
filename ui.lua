-- Lap panel: laps completed, current lap time and fastest lap time.
-- Only displays what it is given; main.lua does the timing and saving.

local const = require("constants")

local Panel = {}

local box, lapsText, currentText, fastestText

-- Ticks as m:ss.s, or "-" when there is no time.
local function formatTicks(ticks)
    if not ticks then return "-" end
    local seconds = ticks * const.TICK_SECONDS
    return string.format("%d:%04.1f", seconds // 60, seconds % 60)
end

local function addLine(row)
    local text = ui.Text.new(box)
    text:SetSize(0, 0, 1.0, 1 / 3)
    text:SetPos(0, 0, 0, (row - 1) / 3)
    text.font = id.Font.MUSEO_SANS_15PT_REGULAR -- text is invisible without a font
    text:AlignTo(ui.AlignMode.CENTRE)
    return text
end

function Panel.create()
    Panel.destroy()
    local parent = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    box = ui.GroupBox.new(parent)
    box.stylesheetID = id.StyleSheet.DEFAULT -- the box is invisible without a stylesheet
    box:SetHeaderLayout(0, 0, 0, 0, 0)
    box:SetSize(const.PANEL_WIDTH, const.PANEL_HEIGHT)
    box:SetPos(0, 0, const.PANEL_X, const.PANEL_Y)
    box.hidden = true

    lapsText = addLine(1)
    currentText = addLine(2)
    fastestText = addLine(3)
    Panel.setLaps(0)
    Panel.setCurrent(nil)
    Panel.setFastest(nil)
end

-- The setters do nothing if the panel couldn't be created.
function Panel.show(shown)
    if box then box.hidden = not shown end
end

function Panel.setLaps(laps)
    if box then lapsText.content = "Laps: " .. laps end
end

function Panel.setCurrent(ticks)
    if box then currentText.content = "Current: " .. formatTicks(ticks) end
end

function Panel.setFastest(ticks)
    if box then fastestText.content = "Fastest: " .. formatTicks(ticks) end
end

function Panel.destroy()
    if box then box:Destroy() end
    box = nil
end

return Panel
