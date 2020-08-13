-----------------------------------------------------------------------------------------------------------------------
--                                                  Menu config                                                      --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local redflat = require("redflat")
local awful = require("awful")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local menu = {}


-- Build function
-----------------------------------------------------------------------------------------------------------------------
function menu:init(args)

	-- vars
	args = args or {}
	local env = args.env or {} -- fix this?
	local separator = args.separator or { widget = redflat.gauge.separator.horizontal() }
	local theme = args.theme or { auto_hotkey = true }
	local icon_style = args.icon_style or { custom_only = true, scalable_only = true }

	-- theme vars
	local default_icon = redflat.util.base.placeholder()
	local icon = redflat.util.table.check(beautiful, "icon.awesome") and beautiful.icon.awesome or default_icon
	local color = redflat.util.table.check(beautiful, "color.icon") and beautiful.color.icon or nil
	local theme_path = awful.util.get_configuration_dir() .. "themes/colored"

	-- icon finder
	local function micon(name)
		return redflat.service.dfparser.lookup_icon(name, icon_style)
	end

	-- extra commands
	local ranger_comm = env.terminal .. " -e ranger"

	-- Application submenu
	------------------------------------------------------------
	local appmenu = redflat.service.dfparser.menu({ icons = icon_style, wm_name = "awesome", base_path = theme_path })

	-- Awesome submenu
	------------------------------------------------------------
	local awesomemenu = {
		{ "Restart",         awesome.restart,                 micon(theme_path .. "/system/reboot.svg") },
		separator,
		{ "Awesome config",  env.fm .. " .config/awesome",        micon(theme_path .. "/applications/folder.svg") },
		{ "Awesome lib",     env.fm .. " /usr/share/awesome/lib", micon(theme_path .. "/applications/folder.svg") }
	}

	-- Places submenu
	------------------------------------------------------------
	local placesmenu = {
		{ "Downloads",   env.fm .. " Downloads", micon(theme_path .. "/folder/downloads.svg")  },
		{ "Documents",   env.fm .. " Documents", micon(theme_path .. "/folder/documents.svg") },
		{ "Home",				 env.fm .. "",					 micon(theme_path .. "/folder/home.svg") },
		separator,
		{ "Media",       env.fm .. " /mnt/media",        micon(theme_path .. "/applications/folder.svg") },
		{ "Storage",     env.fm .. " /run/media/jannik", micon(theme_path .. "/applications/folder.svg") },
	}

	-- Exit submenu
	------------------------------------------------------------
	local exitmenu = {
		{ "Reboot",          "reboot",                    micon(theme_path .. "/system/reboot.svg") },
		{ "Shutdown",        "shutdown now",              micon(theme_path .. "/system/shutdown.svg") },
		separator,
		{ "Switch user",     "dm-tool switch-to-greeter", micon(theme_path .. "/system/switch-users.svg") },
		{ "Hibernate",       "systemctl suspend" ,        micon(theme_path .. "/system/lock.svg") },
		{ "Log out",         awesome.quit,                micon(theme_path .. "/system/log-out.svg") },
	}

	-- Main menu
	------------------------------------------------------------
	self.mainmenu = redflat.menu({ theme = theme,
		items = {
			{ "Awesome",       awesomemenu, 	micon(theme_path .. "/applications/awesome.svg") },
			{ "Applications",  appmenu,     	micon(theme_path .. "/applications/applications.svg"), key = "a" },
			{ "Places",        placesmenu,  	micon(theme_path .. "/applications/folder.svg"), key = "p" },
			separator,
			{ "Terminal",      env.terminal,	micon(theme_path .. "/applications/terminal.svg"), key = "t" },
			{ "Thunar",        env.fm,      	micon(theme_path .. "/applications/folder.svg"), key = "f" },
			{ "Chrome",        "chromium",		micon(theme_path .. "/applications/browser.svg"), key = "c" },
			{ "VS Code",       "code",				micon(theme_path .. "/applications/vscode.svg"), key = "v" },
			{ "Discord",			 "discord",		  micon(theme_path .. "/applications/discord.svg"), key = "d" },
			{ "Spotify",			 "spotify",		  micon(theme_path .. "/applications/spotify.svg"), key = "s" },
			separator,
			{ "Exit",          exitmenu,     micon("exit") },
		}
	})

	-- Menu panel widget
	------------------------------------------------------------

	self.widget = redflat.gauge.svgbox(icon, nil, color)
	self.buttons = awful.util.table.join(
		awful.button({ }, 1, function () self.mainmenu:toggle() end)
	)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return menu
