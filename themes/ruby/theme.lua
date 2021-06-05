-----------------------------------------------------------------------------------------------------------------------
--                                                  Ruby theme                                                       --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- This theme was inherited from another with overwriting some values
-- Check parent theme to find full settings list and its description
local theme = require("themes/colored/theme")


-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color.main					= "#A30817"
theme.color.widget_main		= "#A30817"
theme.color.tasklist_main	= "#A30817"
theme.color.urgent = "#016B84"


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/ruby"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 38 -- panel height
theme.wallpaper    = theme.path .. "/wallpaper/custom.png"
theme.desktopbg    = theme.path .. "/wallpaper/transparent.png"

-- Setup parent theme settings
--------------------------------------------------------------------------------
theme:update()


-- Desktop config
-----------------------------------------------------------------------------------------------------------------------

-- Desktop widgets placement
--------------------------------------------------------------------------------
theme.desktop.grid = {
	width  = { 440, 440 },
	height = { 100, 100, 100, 66, 50 },
	edge   = { width = { 100, 840 }, height = { 100, 100 } }
}

theme.desktop.places = {}

-- Desktop widgets
--------------------------------------------------------------------------------
-- individual widget settings doesn't used by redflat module
-- but grab directly from rc-files to rewrite base style
theme.individual.desktop = { speedmeter = {}, multimeter = {}, multiline = {} }

-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- individual margins for panel widgets
------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 12, 9, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 4, 9, 3, 3 },
	microphone  = { 5, 6, 6, 6 },
	keyboard    = { 9, 9, 3, 3 },
	mail        = { 9, 9, 3, 3 },
	tray        = { 8, 8, 7, 7 },
	cpu         = { 9, 3, 7, 7 },
	ram         = { 2, 2, 7, 7 },
	battery     = { 3, 9, 7, 7 },
	network     = { 4, 4, 7, 7 },
	updates     = { 6, 6, 6, 6 },
	taglist     = { 4, 4, 5, 4 },
	tasklist    = { 10, 0, 0, 0 }, -- centering tasklist widget
}

-- Various widgets style tuning
------------------------------------------------------------

-- Dotcount
--theme.gauge.graph.dots.dot_gap_h = 5

-- System updates indicator
theme.widget.updates.icon = theme.path .. "/widget/updates.svg"

-- Audio
theme.gauge.audio.blue.dash.plain = true
theme.gauge.audio.blue.dash.bar.num = 8
theme.gauge.audio.blue.dash.bar.width = 3
theme.gauge.audio.blue.dmargin = { 5, 0, 9, 9 }
theme.gauge.audio.blue.width = 86
theme.gauge.audio.blue.icon = theme.path .. "/widget/audio.svg"

-- Dash
theme.gauge.monitor.dash.width = 11

-- Tasklist
theme.widget.tasklist.char_digit = 5
theme.widget.tasklist.task = theme.gauge.task.ruby

-- KB layout indicator
theme.widget.keyboard.icon = theme.path .. "/widget/keyboard.svg"

-- Mail
theme.widget.mail.icon = theme.path .. "/widget/mail.svg"

-- Battery
theme.widget.battery.notify = { icon = theme.path .. "/widget/battery.svg", color = theme.color.main }
theme.widget.battery.levels = { 0.05, 0.1, 0.15, 0.2, 0.25, 0.30 }

-- Individual styles
------------------------------------------------------------
theme.individual.microphone_audio = {
	width   = 26,
	--dmargin = { 4, 3, 1, 1 },
	--dash    = { line = { num = 3, height = 5 } },
	icon    = theme.path .. "/widget/microphone.svg",
	color   = { icon = theme.color.main, mute = theme.color.icon }
}

-- Floating widgets
-----------------------------------------------------------------------------------------------------------------------

-- Titlebar helper
theme.float.bartip.names = { "Mini", "Compact", "Full" }

-- Set hotkey helper size according current fonts and keys scheme
--------------------------------------------------------------------------------
theme.float.hotkeys.geometry   = { width = 1420 }
theme.float.appswitcher.keytip = { geometry = { width = 400 }, exit = true }
theme.float.keychain.keytip    = { geometry = { width = 1020 }, column = 2 }
theme.float.top.keytip         = { geometry = { width = 400 } }
theme.widget.updates.keytip    = { geometry = { width = 400 } }
theme.menu.keytip              = { geometry = { width = 400 } }

-- Titlebar
-----------------------------------------------------------------------------------------------------------------------
theme.titlebar.icon_compact = {
	color        = { icon = theme.color.gray, main = theme.color.main, urgent = theme.color.main },
	list         = {
		maximized = theme.path .. "/titlebar/maximized.svg",
		minimized = theme.path .. "/titlebar/minimize.svg",
		close     = theme.path .. "/titlebar/close.svg",
		focus     = theme.path .. "/titlebar/focus.svg",
		unknown   = theme.icon.unknown,
	}
}

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
