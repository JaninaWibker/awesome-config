-----------------------------------------------------------------------------------------------------------------------
--                                                  Environment config                                               --
-----------------------------------------------------------------------------------------------------------------------

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
-- local naughty = require("naughty")

local redflat = require("redflat")

local unpack = unpack or table.unpack

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local env = {}

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function env:init(args)

	-- init vars
	args = args or {}
	-- environment vars
	self.theme = args.theme or "red"
	self.terminal = args.terminal or "alacritty"
	self.mod = args.mod or "Mod4"
	self.fm = args.fm or "thunar"
	self.mail = args.mail or "thunderbird"
	self.player = args.player or "pragha"
	self.updates = args.updates or "bash -c 'pacman -Qu | grep -v ignored | wc -l'"
	self.home = os.getenv("HOME")
	self.themedir = awful.util.get_configuration_dir() .. "themes/" .. self.theme
	-- boolean defaults is pain
	self.sloppy_focus = args.sloppy_focus or false
	self.color_border_focus = args.color_border_focus or false
	self.set_slave = args.set_slave == nil and true or false
	self.set_center = args.set_center or false
	self.desktop_autohide = args.desktop_autohide or false

	-- high dpi
	self.is_high_dpi = true -- os.getenv("HIGH_DPI") == 1 -- TODO: remove "true -- "

	-- light / dark theme
	self.is_light_theme = os.getenv("THEME_VARIANT") ~= "dark"

	-- theme setup
	beautiful.init(env.themedir .. "/theme.lua")

end


-- Common functions
-----------------------------------------------------------------------------------------------------------------------

-- Wallpaper setup
--------------------------------------------------------------------------------
env._wallpaper = function(s, path)
	if path then

		if not env.desktop_autohide and awful.util.file_readable(path) then
			gears.wallpaper.maximized(path, s, true)
		else
			gears.wallpaper.set(beautiful.color and beautiful.color.bg)
		end
	end
end

env.wallpaper = function(s, override)

	local wallpaper

	if type(override) == "function" then
		wallpaper = override(s)
	elseif type(override) == "string" then
		wallpaper = override
	elseif type(beautiful.wallpaper) == "function" then
		wallpaper = beautiful.wallpaper(s)
	else
	 	wallpaper = beautiful.wallpaper
	end

	env._wallpaper(s, wallpaper)
end

-- Tag tooltip text generation
--------------------------------------------------------------------------------
env.tagtip = function(t)
	local layname = awful.layout.getname(awful.tag.getproperty(t, "layout"))
	if redflat.util.table.check(beautiful, "widget.layoutbox.name_alias") then
		layname = beautiful.widget.layoutbox.name_alias[layname] or layname
	end
	return string.format("%s (%d apps) [%s]", t.name, #(t:clients()), layname)
end

-- Panel widgets wrapper
--------------------------------------------------------------------------------
env.wrapper = function(widget, name, buttons)
	local margin = redflat.util.table.check(beautiful, "widget.wrapper")
	               and beautiful.widget.wrapper[name] or { 0, 0, 0, 0 }
	if buttons then
		widget:buttons(buttons)
	end

	return wibox.container.margin(widget, unpack(margin))
end


-- End
-----------------------------------------------------------------------------------------------------------------------
return env
