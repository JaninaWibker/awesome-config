-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local table = table
local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { mouse = {}, raw = {}, keys = {}, fake = {} }

-- key aliases
local appswitcher = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local redtip = redflat.float.hotkeys
local laycom = redflat.layout.common
local grid = redflat.layout.grid
local map = redflat.layout.map
local redtitle = redflat.titlebar

-- Key support functions
-----------------------------------------------------------------------------------------------------------------------

-- change window focus by history
local function focus_to_previous()
	awful.client.focus.history.previous()
	if client.focus then client.focus:raise() end
end

-- change window focus by direction
local focus_switch_byd = function(dir)
	return function()
		awful.client.focus.bydirection(dir)
		if client.focus then client.focus:raise() end
	end
end

-- minimize and restore windows
local function minimize_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) then c.minimized = true end
	end
end

local function minimize_all_except_focused()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c ~= client.focus then c.minimized = true end
	end
end

local function restore_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c.minimized then c.minimized = false end
	end
end

local function restore_client()
	local c = awful.client.restore()
	if c then client.focus = c; c:raise() end
end

-- close window
local function kill_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and not c.sticky then c:kill() end
	end
end

-- new clients placement
local function toggle_placement(env)
	env.set_slave = not env.set_slave
	redflat.float.notify:show({ text = (env.set_slave and "Slave" or "Master") .. " placement" })
end

-- numeric keys function builders
local function tag_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then action(tag) end
		end
	)
end

local function client_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then action(tag) end
			end
		end
	)
end

-- brightness functions
local brightness = function(args)
	redflat.float.brightness:change_with_xbacklight(args) -- use xbacklight
end

-- right bottom corner position
local rb_corner = function()
	return { x = screen[mouse.screen].workarea.x + screen[mouse.screen].workarea.width,
	         y = screen[mouse.screen].workarea.y + screen[mouse.screen].workarea.height }
end

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

	-- Init vars
	args = args or {}
	local env = args.env
	local volume = args.volume
	local mainmenu = args.menu
	local appkeys = args.appkeys or {}

	self.mouse.root = (awful.util.table.join(
		awful.button({ }, 3, function () mainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	))

	-- volume functions
	local volume_raise = function() volume:change_volume({ show_notify = true })              end
	local volume_lower = function() volume:change_volume({ show_notify = true, down = true }) end
	local volume_mute  = function() volume:mute() end

	-- Application hotkeys helper
	--------------------------------------------------------------------------------
	local apphelper = function(keys)
		if not client.focus then return end

		local app = client.focus.class:lower()
		for name, sheet in pairs(keys) do
			if name == app then
				redtip:set_pack(
						client.focus.class, sheet.pack, sheet.style.column, sheet.style.geometry,
						function() redtip:remove_pack() end
				)
				redtip:show()
				return
			end
		end

		redflat.float.notify:show({ text = "No tips for " .. client.focus.class })
	end

	-- Keys for widgets
	--------------------------------------------------------------------------------


	-- Menu widget
	------------------------------------------------------------
	local menu_keys_move = {
		{
			{ env.mod }, "k", redflat.menu.action.down,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "i", redflat.menu.action.up,
			{ description = "Select previous item", group = "Navigation" }
		},
		{
			{ env.mod }, "j", redflat.menu.action.back,
			{ description = "Go back", group = "Navigation" }
		},
		{
			{ env.mod }, "l", redflat.menu.action.enter,
			{ description = "Open submenu", group = "Navigation" }
		},
	}

	-- redflat.menu:set_keys(awful.util.table.join(redflat.menu.keys.move, menu_keys_move), "move")
	redflat.menu:set_keys(menu_keys_move, "move")

	-- Appswitcher widget
	------------------------------------------------------------
	local appswitcher_keys = {
		{
			{ env.mod }, "a", function() appswitcher:switch({ reverse = true }) end,
			{ description = "Select next app", group = "Navigation" }
		},
		{
			{ env.mod }, "Right", function() appswitcher:switch({ reverse = true }) end,
			{} -- hidden key
		},
		{
			{ env.mod, "Shift" }, "a", function() appswitcher:switch({ reverse = true }) end,
			{} -- hidden key
		},
		{
			{ env.mod }, "s", function() appswitcher:switch() end,
			{ description = "Select previous app", group = "Navigation" }
		},
		{
			{ env.mod }, "Left", function() appswitcher:switch() end,
			{} -- hidden key
		},
		{
			{ env.mod, "Shift" }, "s", function() appswitcher:switch() end,
			{} -- hidden key
		},
		{
			{ env.mod }, "q", function() appswitcher:close_current() end,
			{ description = "Quit application", group = "Action" }
		},
		{
			{ env.mod, "Shift" }, "q", function() appswitcher:close_current() end,
			{} -- hidden key
		},
		{
			{}, "Super_L", function() appswitcher:hide() end,
			{ description = "Activate and exit", group = "Action" }
		},
		{
			{ env.mod }, "Super_L", function() appswitcher:hide() end,
			{} -- hidden key
		},
		{
			{ env.mod, "Shift" }, "Super_L", function() appswitcher:hide() end,
			{} -- hidden key
		},
		{
			{}, "Return", function() appswitcher:hide() end,
			{ description = "Activate and exit", group = "Action" }
		},
		{
			{}, "Escape", function() appswitcher:hide(true) end,
			{ description = "Exit", group = "Action" }
		},
		{
			{ env.mod }, "Escape", function() appswitcher:hide(true) end,
			{} -- hidden key
		},
		{
			{ env.mod }, "F1", function() redtip:show()  end,
			{ description = "Show hotkeys helper", group = "Action" }
		},
	}

	appswitcher:set_keys(appswitcher_keys)

	-- Emacs like key sequences
	--------------------------------------------------------------------------------

	-- initial key
	local keyseq = { { env.mod }, "c", {}, {} }

	-- group
	keyseq[3] = {
		{ {}, "k", {}, {} }, -- application kill group
		{ {}, "c", {}, {} }, -- client managment group
		{ {}, "r", {}, {} }, -- client managment group
		{ {}, "n", {}, {} }, -- client managment group
		{ {}, "g", {}, {} }, -- run or rise group
		{ {}, "f", {}, {} }, -- launch application group
	}

	-- application kill sequence actions
	keyseq[3][1][3] = {
		{
			{}, "f", function() if client.focus then client.focus:kill() end end,
			{ description = "Kill focused client", group = "Kill application", keyset = { "f" } }
		},
		{
			{}, "a", kill_all,
			{ description = "Kill all clients with current tag", group = "Kill application", keyset = { "a" } }
		},
	}

	-- client managment sequence actions
	keyseq[3][2][3] = {
		{
			{}, "p", function () toggle_placement(env) end,
			{ description = "Switch master/slave window placement", group = "Clients managment", keyset = { "p" } }
		},
	}

	keyseq[3][3][3] = {
		{
			{}, "f", restore_client,
			{ description = "Restore minimized client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", restore_all,
			{ description = "Restore all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
	}

	keyseq[3][4][3] = {
		{
			{}, "f", function() if client.focus then client.focus.minimized = true end end,
			{ description = "Minimized focused client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", minimize_all,
			{ description = "Minimized all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
		{
			{}, "e", minimize_all_except_focused,
			{ description = "Minimized all clients except focused", group = "Clients managment", keyset = { "e" } }
		},
	}


	-- Layouts
	--------------------------------------------------------------------------------

	-- shared layout keys
	local layout_tile = {
		{
			{ env.mod }, "l", function () awful.tag.incmwfact( 0.05) end,
			{ description = "Increase master width factor", group = "Layout" }
		},
		{
			{ env.mod }, "h", function () awful.tag.incmwfact(-0.05) end,
			{ description = "Decrease master width factor", group = "Layout" }
		},
		{
			{ env.mod }, "k", function () awful.client.incwfact( 0.05) end,
			{ description = "Increase window factor of a client", group = "Layout" }
		},
		{
			{ env.mod }, "j", function () awful.client.incwfact(-0.05) end,
			{ description = "Decrease window factor of a client", group = "Layout" }
		},
		{
			{ env.mod, }, "+", function () awful.tag.incnmaster( 1, nil, true) end,
			{ description = "Increase the number of master clients", group = "Layout" }
		},
		{
			{ env.mod }, "-", function () awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Decrease the number of master clients", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "+", function () awful.tag.incncol( 1, nil, true) end,
			{ description = "Increase the number of columns", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "-", function () awful.tag.incncol(-1, nil, true) end,
			{ description = "Decrease the number of columns", group = "Layout" }
		},
	}

	laycom:set_keys(layout_tile, "tile")

	-- grid layout keys
	local layout_grid_move = {
		{
			{ env.mod }, "KP_Up", function() grid.move_to("up") end,
			{ description = "Move window up", group = "Movement" }
		},
		{
			{ env.mod }, "KP_Down", function() grid.move_to("down") end,
			{ description = "Move window down", group = "Movement" }
		},
		{
			{ env.mod }, "KP_Left", function() grid.move_to("left") end,
			{ description = "Move window left", group = "Movement" }
		},
		{
			{ env.mod }, "KP_right", function() grid.move_to("right") end,
			{ description = "Move window right", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Up", function() grid.move_to("up", true) end,
			{ description = "Move window up by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Down", function() grid.move_to("down", true) end,
			{ description = "Move window down by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Left", function() grid.move_to("left", true) end,
			{ description = "Move window left by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Right", function() grid.move_to("right", true) end,
			{ description = "Move window right by bound", group = "Movement" }
		},
	}

	local layout_grid_resize = {
		{
			{ env.mod }, "k", function() grid.resize_to("up") end,
			{ description = "Increase window size upwards", group = "Resize" }
		},
		{
			{ env.mod }, "j", function() grid.resize_to("down") end,
			{ description = "Increase window size downwards", group = "Resize" }
		},
		{
			{ env.mod }, "h", function() grid.resize_to("left") end,
			{ description = "Increase window size to the left", group = "Resize" }
		},
		{
			{ env.mod }, "l", function() grid.resize_to("right") end,
			{ description = "Increase window size to the right", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "j", function() grid.resize_to("up", nil, true) end,
			{ description = "Decrease window size from the top", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "k", function() grid.resize_to("down", nil, true) end,
			{ description = "Decrease window size from the bottom", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "l", function() grid.resize_to("left", nil, true) end,
			{ description = "Decrease window size from the left", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "h", function() grid.resize_to("right", nil, true) end,
			{ description = "Decrease window size from the right", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "k", function() grid.resize_to("up", true) end,
			{ description = "Increase window size upwards by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "j", function() grid.resize_to("down", true) end,
			{ description = "Increase window size downwards by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "h", function() grid.resize_to("left", true) end,
			{ description = "Increase window size to the left by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "l", function() grid.resize_to("right", true) end,
			{ description = "Increase window size to the right by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "j", function() grid.resize_to("up", true, true) end,
			{ description = "Decrease window size from the top by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "k", function() grid.resize_to("down", true, true) end,
			{ description = "Decrease window size from the bottom by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "l", function() grid.resize_to("left", true, true) end,
			{ description = "Decrease window size from the left by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "h", function() grid.resize_to("right", true, true) end,
			{ description = "Decrease window size from the right by bound ", group = "Resize" }
		},
	}

	redflat.layout.grid:set_keys(layout_grid_move, "move")
	redflat.layout.grid:set_keys(layout_grid_resize, "resize")

	-- user map layout keys
	local layout_map_layout = {
		{
			{ env.mod, "Mod1" }, "s", function() map.swap_group() end,
			{ description = "Change placement direction for group", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "v", function() map.new_group(true) end,
			{ description = "Create new vertical group", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "h", function() map.new_group(false) end,
			{ description = "Create new horizontal group", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "v", function() map.insert_group(true) end,
			{ description = "Insert new vertical group before active", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "h", function() map.insert_group(false) end,
			{ description = "Insert new horizontal group before active", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "d", function() map.delete_group() end,
			{ description = "Destroy group", group = "Layout" }
		},
		{
			{ env.mod, "Mod1" }, "d", function() map.clean_groups() end,
			{ description = "Destroy all empty groups", group = "Layout" }
		},
		{
			{ env.mod }, "f", function() map.set_active() end,
			{ description = "Set active group", group = "Layout" }
		},
		{
			{ env.mod }, "g", function() map.move_to_active() end,
			{ description = "Move focused client to active group", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "f", function() map.hilight_active() end,
			{ description = "Highlight active group", group = "Layout" }
		},
		{
			{ env.mod }, "a", function() map.switch_active(-1) end,
			{ description = "Activate next group", group = "Layout" }
		},
		{
			{ env.mod }, "s", function() map.switch_active(1) end,
			{ description = "Activate previous group", group = "Layout" }
		},
		{
			{ env.mod }, "]", function() map.move_group(1) end,
			{ description = "Move active group to the top", group = "Layout" }
		},
		{
			{ env.mod }, "[", function() map.move_group(-1) end,
			{ description = "Move active group to the bottom", group = "Layout" }
		},
		{
			{ env.mod }, "r", function() map.reset_tree() end,
			{ description = "Reset layout structure", group = "Layout" }
		},
	}

	local layout_map_resize = {
		{
			{ env.mod }, "l", function() map.incfactor(nil, 0.1, false) end,
			{ description = "Increase window horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod }, "h", function() map.incfactor(nil, -0.1, false) end,
			{ description = "Decrease window horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod }, "j", function() map.incfactor(nil, 0.1, true) end,
			{ description = "Increase window vertical size factor", group = "Resize" }
		},
		{
			{ env.mod }, "k", function() map.incfactor(nil, -0.1, true) end,
			{ description = "Decrease window vertical size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "l", function() map.incfactor(nil, 0.1, false, true) end,
			{ description = "Increase group horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "h", function() map.incfactor(nil, -0.1, false, true) end,
			{ description = "Decrease group horizontal size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "j", function() map.incfactor(nil, 0.1, true, true) end,
			{ description = "Increase group vertical size factor", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "k", function() map.incfactor(nil, -0.1, true, true) end,
			{ description = "Decrease group vertical size factor", group = "Resize" }
		},
	}

	redflat.layout.map:set_keys(layout_map_layout, "layout")
	redflat.layout.map:set_keys(layout_map_resize, "resize")


	-- Global keys
	--------------------------------------------------------------------------------
	self.raw.root = {
		{ -- TODO: maybe think of a better shortcut for this feature (F keys are pretty annoying to hit)
			{ env.mod }, "F1", function() redtip:show() end,
			{ description = "[Hold] Show awesome hotkeys helper", group = "Main" }
		},
		{ -- TODO: maybe think of a better shortcut for this feature (F keys are pretty annoying to hit)
			{ env.mod, "Control" }, "F1", function() apphelper(appkeys) end,
			{ description = "[Hold] Show hotkeys helper for application", group = "Main" }
		},

		{ -- TODO: maybe think of a better shortcut for this feature (F keys are pretty annoying to hit)
			{ env.mod }, "F2", function () redflat.service.navigator:run() end,
			{ description = "[Hold] Tiling window control mode", group = "Window control" }
		},
		{
			{ env.mod }, "i", function() redflat.float.control:show() end,
			{ description = "[Hold] Floating window control mode", group = "Window control" }
		},

		{
			{ env.mod }, "Return", function() awful.spawn(env.terminal) end,
			{ description = "Open a terminal", group = "Actions" }
		},
		{
			{ env.mod, "Control" }, "r", awesome.restart,
			{ description = "Reload WM", group = "Actions" }
		},

		{
			{ env.mod, "Mod1" }, "l", function() awful.spawn.with_shell("sh $HOME/scripts/lock-screen screen-off") end,
			{ description = "lock the screen", group = "Actions" }
		},

		{
			{ env.mod, "Shift" }, "k", function() awful.screen.focus_relative( 1) end,
			{ description = "focus the next screen", group = "screen" }
		},
		{
			{ env.mod, "Shift" }, "j", function() awful.screen.focus_relative(-1) end,
			{ description = "focus the previous screen", group = "screen" }
		},

		{
			{ env.mod }, "l", focus_switch_byd("right"),
			{ description = "Go to right client", group = "Client focus" }
		},
		{
			{ env.mod }, "h", focus_switch_byd("left"),
			{ description = "Go to left client", group = "Client focus" }
		},
		{
			{ env.mod }, "k", focus_switch_byd("up"),
			{ description = "Go to upper client", group = "Client focus" }
		},
		{
			{ env.mod }, "j", focus_switch_byd("down"),
			{ description = "Go to lower client", group = "Client focus" }
		},
		{
			{ env.mod }, "u", awful.client.urgent.jumpto,
			{ description = "Go to urgent client", group = "Client focus" }
		},
		{
			{ env.mod }, "Tab", focus_to_previous,
			{ description = "Go to previous client", group = "Client focus" }
		},

		{
			{ env.mod }, "w", function() mainmenu:show() end,
			{ description = "Show main menu", group = "Widgets" }
		},
		{
			{ env.mod }, "d", function() awful.spawn("/usr/bin/dmenu_run") end,
			{ description = "launch dmenu", group = "Widgets" }
		},
		{
			{ env.mod }, "r", function () awful.spawn("/usr/bin/rofi -modi combi,calc,run -combi-modi window,drun,ssh,run -show combi -no-history -no-sort -no-show-match -calc-command \"echo '{result} | xclip'\"") end,
			{ description = "launch rofi", group = "Widgets" }
		},
		{
			{ env.mod }, "space", function() awful.spawn("/usr/bin/rofi -modi calc,drun,window -show calc -no-history -no-sort -no-show-match -calc-command \"echo '{result} | pbcopy'\"") end,
			{ description = "launch rofi", group = "Widgets" }
		},
		{
			{ env.mod }, "F3", function() awful.spawn.with_shell("sh $HOME/scripts/script-launcher") end,
			{ description = "script launcher (rofi)", group = "Widgets" }
		},
		{
			{ env.mod }, "F4", function() awful.spawn.with_shell("if command -v rofimoji; then rofimoji; else notify-send -u critical 'rofimoji not installed'; fi") end,
			{ description = "emojipicker (rofimoji)", group = "Widgets" }
		},
		{
			{ env.mod }, "F5", function() awful.spawn.with_shell("if command -v xfce4-find-cursor; then xfce4-find-cursor; else notify-send -u critical 'xfce4-find-cursor not installed'; fi") end,
			{ description = "find cursor", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "1", function() awful.spawn.with_shell("$HOME/programs/boomer/boomer") end,
			{ description = "Zoom mode (boomer)", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "2", function() awful.spawn("/usr/bin/flameshot full -c") end,
			{ description = "Take screenshot (full)", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "3", function() awful.spawn("/usr/bin/flameshot screen -c") end,
			{ description = "Take screenshot (screen)", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "F2", function() awful.spawn("/usr/bin/flameshot full -c -d 2000") end,
			{ description = "Take screenshot (full; delay 2s)", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "F3", function() awful.spawn("/usr/bin/flameshot screen -c -d 2000") end,
			{ description = "Take screenshot (screen; delay 2s)", group = "Widgets" }
		},
		{
			{ "Control", "Shift" }, "4", function() awful.spawn("/usr/bin/flameshot gui") end,
			{ description = "Take screenshot (area)", group = "Widgets" }
		},
		{
			{ env.mod }, "x", function() redflat.float.top:show("cpu") end,
			{ description = "Show the top process list", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "i", function() redflat.widget.minitray:toggle() end,
			{ description = "Show minitray", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "u", function() redflat.widget.updates:update(true) end,
			{ description = "Check available updates", group = "Widgets" }
		},
		{
			{ "Mod4" }, "g", function () awful.client.setmaster(client.focus) end,
			{ description = "Set focused client as master", group = "Movement" }
		},

		{
			{ env.mod }, "y", function() laybox:toggle_menu(mouse.screen.selected_tag) end,
			{ description = "Show layout menu", group = "Layouts" }
		},
		{
			{ env.mod }, "Up", function() awful.layout.inc(1) end,
			{ description = "Select next layout", group = "Layouts" }
		},
		{
			{ env.mod }, "Down", function() awful.layout.inc(-1) end,
			{ description = "Select previous layout", group = "Layouts" }
		},

		{
			{}, "XF86MonBrightnessUp", function() brightness({ step = 2 }) end,
			{ description = "Increase brightness", group = "Brightness control" }
		},
		{
			{}, "XF86MonBrightnessDown", function() brightness({ step = 2, down = true }) end,
			{ description = "Reduce brightness", group = "Brightness control" }
		},

		{
			{}, "XF86AudioRaiseVolume", volume_raise,
			{ description = "Increase volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioLowerVolume", volume_lower,
			{ description = "Reduce volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioMute", volume_mute,
			{ description = "Mute audio", group = "Volume control" }
		},

		{
			{ env.mod }, "a", nil, function() appswitcher:show({ filter = current, reverse = true  }) end,
			{ description = "Switch to next with current tag", group = "Application switcher" }
		},
		{
			{ env.mod }, "s", nil, function() appswitcher:show({ filter = current}) end,
			{ description = "Switch to previous with current tag", group = "Application switcher" }
		},
		{
			{ env.mod, "Shift" }, "a", nil, function() appswitcher:show({ filter = allscr, reverse = true  }) end,
			{ description = "Switch to next through all tags", group = "Application switcher" }
		},
		{
			{ env.mod, "Shift" }, "s", nil, function() appswitcher:show({ filter = allscr}) end,
			{ description = "Switch to previous through all tags", group = "Application switcher" }
		},

		{
			{ env.mod }, "Escape", awful.tag.history.restore,
			{ description = "Go previous tag", group = "Tag navigation" }
		},
		{
			{ env.mod }, "Right", awful.tag.viewnext,
			{ description = "View next tag", group = "Tag navigation" }
		},
		{
			{ env.mod }, "Left", awful.tag.viewprev,
			{ description = "View previous tag", group = "Tag navigation" }
		},

		{
			{ env.mod }, "t", function() redtitle.toggle(client.focus) end,
			{ description = "Show/hide titlebar for focused client", group = "Titlebar" }
		},
		--{
		--	{ env.mod, "Control" }, "t", function() redtitle.switch(client.focus) end,
		--	{ description = "Switch titlebar view for focused client", group = "Titlebar" }
		--},
		{
			{ env.mod, "Shift" }, "t", function() redtitle.toggle_all() end,
			{ description = "Show/hide titlebar for all clients", group = "Titlebar" }
		},
		{
			{ env.mod, "Control", "Shift" }, "t", function() redtitle.global_switch() end,
			{ description = "Switch titlebar view for all clients", group = "Titlebar" }
		},
		{
			{ env.mod }, "e", function() awful.spawn(env.fm) end,
			{ description = "Open filemanager", group = "Widgets" }
		},

		-- {
		-- 	{ env.mod }, "e", function() redflat.float.player:show(rb_corner()) end,
		-- 	{ description =    "Show/hide widget", group = "Audio player" }
		-- },
		{
			{}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end,
			{ description = "Previous track", group = "Audio player" }
		},
		{
			{}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end,
			{ description = "Play/Pause track", group = "Audio player" }
		},
		{
			{}, "XF86AudioNext", function() awful.spawn("playerctl next") end,
			{ description = "Next track", group = "Audio player" }
		},

		{
			{ env.mod }, "F7", function() awful.spawn("playerctl next") end,
			{ description = "Next track", group = "Audio player" }
		},
		{
			{ env.mod }, "F8", function() awful.spawn("playerctl play-pause") end,
			{ description = "Play/Pause track", group = "Audio player" }
		},
		
		{
			{ env.mod }, "F9", function() awful.spawn("playerctl previous") end,
			{ description = "Previous track", group = "Audio player" }
		},
	}

	-- Client keys
	--------------------------------------------------------------------------------
	self.raw.client = {
		{
			{ env.mod }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
			{ description = "Toggle fullscreen", group = "Client keys" }
		},
		{
			{ env.mod, "Shift" }, "q", function(c) c:kill() end,
			{ description = "Close", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "f", awful.client.floating.toggle,
			{ description = "Toggle floating", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "o", function(c) c.ontop = not c.ontop end,
			{ description = "Toggle keep on top", group = "Client keys" }
		},
		{
			{ env.mod }, "n", function(c) c.minimized = true end,
			{ description = "Minimize", group = "Client keys" }
		},
		{
			{ env.mod }, "m", function(c) c.maximized = not c.maximized; c:raise() end,
			{ description = "Maximize", group = "Client keys" }
		},
		{
			{ env.mod, "Shift" }, "l", function(c) c:move_to_screen(c.screen.index+1) end,
			{ description = "move client to next screen", group = "screen" }
		},
		{
			{ env.mod, "Shift" }, "h", function(c) c:move_to_screen(c.screen.index-1) end,
			{ description = "move client to previous screen", group = "screen" }
		}
	}

	self.keys.root = redflat.util.key.build(self.raw.root)
	self.keys.client = redflat.util.key.build(self.raw.client)

	-- Numkeys
	--------------------------------------------------------------------------------

	-- add real keys without description here
	for i = 1, 9 do
		self.keys.root = awful.util.table.join(
			self.keys.root,
			tag_numkey(i,    { env.mod },                     function(t) t:view_only()               end),
			tag_numkey(i,    { env.mod, "Control" },          function(t) awful.tag.viewtoggle(t)     end),
			client_numkey(i, { env.mod, "Shift" },            function(t) client.focus:move_to_tag(t) end),
			client_numkey(i, { env.mod, "Control", "Shift" }, function(t) client.focus:toggle_tag(t)  end)
		)
	end

	-- make fake keys with description special for key helper widget
	local numkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

	self.fake.numkeys = {
		{
			{ env.mod }, "1..9", nil,
			{ description = "Switch to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control" }, "1..9", nil,
			{ description = "Toggle tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Shift" }, "1..9", nil,
			{ description = "Move focused client to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control", "Shift" }, "1..9", nil,
			{ description = "Toggle focused client on tag", group = "Numeric keys", keyset = numkeys }
		},
	}

	-- Hotkeys helper setup
	--------------------------------------------------------------------------------
	redflat.float.hotkeys:set_pack("Main", awful.util.table.join(self.raw.root, self.raw.client, self.fake.numkeys), 2)

	-- Mouse buttons
	--------------------------------------------------------------------------------
	self.mouse.client = awful.util.table.join(
		awful.button({}, 1, function (c) client.focus = c; c:raise() end),
		awful.button({}, 2, awful.mouse.client.move),
		awful.button({ env.mod }, 3, awful.mouse.client.resize),
		awful.button({}, 8, function(c) c:kill() end)
	)

	-- Set root hotkeys
	--------------------------------------------------------------------------------
	root.keys(self.keys.root)
	root.buttons(self.mouse.root)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
