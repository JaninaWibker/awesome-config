-----------------------------------------------------------------------------------------------------------------------
--                                                   Blue theme                                                      --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- This theme was inherited from another with overwriting some values
-- Check parent theme to find full settings list and its description
local theme = require("themes/colored/theme")


-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color.main   = "#B614AB" -- this is a modified version of the accent color of web.jannik.ml
theme.color.main   = "#ff4d6a" -- this is one of the colors of the cyberpunk vscode theme
theme.color.main   = "#ff00aa" -- this is another one of the colors of the cyberpunk vscode theme
theme.color.urgent = "#B32601"


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/blue"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 24 -- panel height -- TODO: change this to like 24 or something (breaks other things)
-- theme.wallpaper    = theme.path .. "/wallpaper/custom.jpg"
-- theme.wallpaper_vertical = theme.path .. "/wallpaper/315.jpg"

theme.wallpaper = function(s)

	if s.geometry.width > s.geometry.height then
		-- leftmost monitor index 1
		-- middle monitors index 2 & 3
		-- rightmost monitor index 4
		return theme.path .. "/wallpaper/astronaut-jellyfish-space.jpg"
	elseif s.index == 2 then
		return theme.path .. "/wallpaper/astronaut-jellyfish-left.png"
	elseif s.index == 3 then
		return theme.path .. "/wallpaper/astronaut-jellyfish-right.png"
	end
end
-- Setup parent theme settings
--------------------------------------------------------------------------------
theme:update()


-- Desktop config
-----------------------------------------------------------------------------------------------------------------------

-- Desktop widgets placement
--------------------------------------------------------------------------------
theme.desktop.grid = {
	width  = { 520, 520, 520 },
	height = { 180, 160, 160, 138, 18 },
	edge   = { width = { 60, 60 }, height = { 40, 40 } }
}

theme.desktop.places = {
}

-- Desktop widgets
--------------------------------------------------------------------------------
-- individual widget settings doesn't used by redflat module
-- but grab directly from rc-files to rewrite base style
theme.individual.desktop = { speedmeter = {}, multimeter = {}, multiline = {}, singleline = {} }

-- Multilines disks (individual widget)
theme.individual.desktop.multiline.disks = {
	unit  = { { "KB", 1 }, { "MB", 1024^1 }, { "GB", 1024^2 } },
	lines = { show = { text = false } },
}

-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- individual margins for panel widgets
--------------------------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 12, 10, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 10, 10, 5, 5 },
	network     = { 10, 10, 0, 0 },
	-- battery     = { 8, 10, 7, 7 },
	tray        = { 8, 8, 7, 7 },
	tasklist    = { 4, 0, 0, 0 }, -- centering tasklist widget
}

-- Various widgets style tuning
------------------------------------------------------------
theme.widget.tasklist.char_digit = 9
theme.widget.tasklist.task = theme.gauge.task.blue

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
