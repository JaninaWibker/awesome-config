-----------------------------------------------------------------------------------------------------------------------
--                                                   Blue theme                                                      --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- local naughty = require("naughty")
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

	local clients = ""
	for i, client in ipairs(s.all_clients) do
		clients = clients .. ", " .. v
	end

		-- naughty.notify({
		-- 	title   = "wallpaper",
		-- 	timeout = 1,
		-- 	text    = "\nindex: " .. s.index .. ", width: " .. s.geometry.width .. ", height: " .. s.geometry.height .. ", clients: " .. clients
		-- })

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
-- TODO: COMMENT OUT START
theme.desktop.places = {
	-- netspeed = { 1, 1 },
	-- ssdspeed = { 2, 1 },
	-- hddspeed = { 3, 1 },
	-- cpumem   = { 1, 2 },
	-- transm   = { 1, 3 },
	-- disks    = { 1, 4 },
	-- thermal  = { 1, 5 }
}
-- TODO: COMMENT OUT END
-- Desktop widgets
--------------------------------------------------------------------------------
-- individual widget settings doesn't used by redflat module
-- but grab directly from rc-files to rewrite base style
theme.individual.desktop = { speedmeter = {}, multimeter = {}, multiline = {}, singleline = {} }
-- -- Speedmeter (base widget)
-- theme.desktop.speedmeter.normal.images = { theme.path .. "/desktop/up.svg", theme.path .. "/desktop/down.svg" }

-- -- Speedmeter drive (individual widget)
-- theme.individual.desktop.speedmeter.drive = {
-- 	unit   = { { "B", -1 }, { "KB", 2 }, { "MB", 2048 } },
-- }

-- -- Multimeter (base widget)
-- theme.desktop.multimeter.lines.show = { label = false, tooltip = false, text = true }

-- -- Multimeter cpu and ram (individual widget)
-- theme.individual.desktop.multimeter.cpumem = {
-- 	labels = { "RAM", "SWAP" },
-- 	icon   = { image = theme.path .. "/desktop/bstar.svg" }
-- }

-- -- Multimeter transmission info (individual widget)
-- theme.individual.desktop.multimeter.transmission = {
-- 	labels = { "SEED", "DNLD" },
-- 	unit   = { { "KB", -1 }, { "MB", 1024^1 } },
-- 	icon   = { image = theme.path .. "/desktop/skull.svg" }
-- }
-- Multilines disks (individual widget)
theme.individual.desktop.multiline.disks = {
	unit  = { { "KB", 1 }, { "MB", 1024^1 }, { "GB", 1024^2 } },
	lines = { show = { text = false } },
}

-- -- Singleline temperature (individual widget)
-- theme.individual.desktop.singleline.thermal = {
-- 	icon = theme.path .. "/desktop/star.svg",
-- 	unit = { { "°C", -1 } },
-- }


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- individual margins for panel widgets
--------------------------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 12, 10, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 10, 10, 5, 5 },
	-- network     = { 10, 10, 5, 5 },
	-- cpuram      = { 10, 10, 5, 5 },
	-- keyboard    = { 10, 10, 4, 4 },
	-- mail        = { 10, 10, 4, 4 },
	-- battery     = { 8, 10, 7, 7 },
	tray        = { 8, 8, 7, 7 },
	tasklist    = { 4, 0, 0, 0 }, -- centering tasklist widget
}

-- Various widgets style tuning
------------------------------------------------------------
theme.widget.tasklist.char_digit = 8
theme.widget.tasklist.task = theme.gauge.task.blue

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
