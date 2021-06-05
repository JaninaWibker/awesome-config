-----------------------------------------------------------------------------------------------------------------------
--                                                    Blue config                                                    --
-----------------------------------------------------------------------------------------------------------------------

-- Load modules
-----------------------------------------------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("awful.autofocus")

-- User modules
------------------------------------------------------------
local redflat = require("redflat")

-- debug locker
local lock = lock or {}

redflat.startup.locked = lock.autostart
redflat.startup:activate()


-- Error handling
-----------------------------------------------------------------------------------------------------------------------
require("colorless.ercheck-config") -- load file with error handling


-- Setup theme and environment vars
-----------------------------------------------------------------------------------------------------------------------
local env = require("color.blue.env-config") -- load file with environment
env:init({ theme = "blue" })


-- Layouts setup
-----------------------------------------------------------------------------------------------------------------------
local layouts = require("color.blue.layout-config") -- load file with tile layouts setup
layouts:init()


-- Main menu configuration
-----------------------------------------------------------------------------------------------------------------------
local mymenu = require("color.blue.menu-config") -- load file with menu configuration
mymenu:init({ env = env })


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- Separator
--------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

-- load list of app name aliases from files and set it as part of tasklist theme
tasklist.style = { appnames = require("color.blue.alias-config")}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	awful.button({}, 2, redflat.widget.tasklist.action.close),
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { separator = separator, widget = redflat.gauge.tag.blue.new, show_tip = true }
taglist.buttons = awful.util.table.join(
	awful.button({         }, 1, function(t) t:view_only() end),
	awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
	awful.button({         }, 2, awful.tag.viewtoggle),
	awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
	awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
	awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock({ timeformat = "%H:%M:%S (%d.%m)", dateformat = "%b  %d  %a", timeout = 1 })

local calendar_widget = redflat.float.calendar({
	-- options like theme or placement
	placement = "top_right",
	is_high_dpi = env.is_high_dpi,
	theme = env.is_light_theme and 'light' or 'dark'
})

textclock.buttons = awful.util.table.join(
	awful.button({}, 1, function() calendar_widget.toggle() end)
)

-- Software update indcator
--------------------------------------------------------------------------------
redflat.widget.updates:init({ command = env.updates, command_action = env.updates_action })

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
	awful.button({ }, 1, function () mymenu.mainmenu:toggle() end),
	awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
	awful.button({ }, 4, function () awful.layout.inc( 1) end),
	awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray()

tray.buttons = awful.util.table.join(
	awful.button({}, 1, function() redflat.widget.minitray:toggle() end)
)

-- PA volume control
--------------------------------------------------------------------------------
local volume = {}
volume.widget = redflat.widget.pulse(nil, { widget = redflat.gauge.audio.blue.new })

-- activate player widget
redflat.float.player:init({ name = env.player })

volume.buttons = awful.util.table.join(
	awful.button({}, 1, function() awful.spawn.with_shell("pgrep pavucontrol && pkill -9 pavucontrol || pavucontrol") end),
	awful.button({}, 2, function() volume.widget:mute()                         end),
	awful.button({}, 3, function() redflat.float.player:show()                  end),
	awful.button({}, 4, function() volume.widget:change_volume()                end),
	awful.button({}, 5, function() volume.widget:change_volume({ down = true }) end),
	awful.button({}, 8, function() redflat.float.player:action("Previous")      end),
	awful.button({}, 9, function() redflat.float.player:action("Next")          end)
)

-- Keyboard layout indicator
--------------------------------------------------------------------------------
local kbindicator = {}
redflat.widget.keyboard:init({ "English", "German" })
kbindicator.widget = redflat.widget.keyboard()

kbindicator.buttons = awful.util.table.join(
	awful.button({}, 1, function () redflat.widget.keyboard:toggle_menu() end),
	awful.button({}, 4, function () redflat.widget.keyboard:toggle()      end),
	awful.button({}, 5, function () redflat.widget.keyboard:toggle(true)  end)
)

-- System resource monitoring widgets
--------------------------------------------------------------------------------
local sysmon = { widget = {}, buttons = {}, icon = {} }

-- icons
sysmon.icon.battery = redflat.util.table.check(beautiful, "wicon.battery")
sysmon.icon.network = redflat.util.table.check(beautiful, "wicon.wireless")
sysmon.icon.cpuram = redflat.util.table.check(beautiful, "wicon.monitor")

-- battery
-- sysmon.widget.battery = redflat.widget.sysmon(
-- 	{ func = redflat.system.pformatted.bat(25), arg = "BAT0" },
-- 	{ timeout = 60, widget = redflat.gauge.icon.single, monitor = { is_vertical = true, icon = sysmon.icon.battery } }
-- )

-- network speed
sysmon.widget.network = redflat.widget.net(
	{
		interface = "eno1", -- "wlp60s0",
		alert = { up = 5 * 1024^2, down = 5 * 1024^2 },
		speed = { up = 6 * 1024^2, down = 6 * 1024^2 },
		autoscale = false
	},
	{ timeout = 2, widget = redflat.gauge.monitor.double, monitor = { icon = sysmon.icon.network } }
)

-- CPU and RAM usage
local cpu_storage = { cpu_total = {}, cpu_active = {} }

local cpuram_func = function()
	local cpu_usage = redflat.system.cpu_usage(cpu_storage).total
	local mem_usage = redflat.system.memory_info().usep

	return {
		text = "cpu: " .. cpu_usage .. "%  " .. "ram: " .. mem_usage .. "%",
		value = { cpu_usage / 100,  mem_usage / 100},
		alert = cpu_usage > 80 or mem_usage > 70
	}
end

sysmon.widget.cpuram = redflat.widget.sysmon(
	{ func = cpuram_func },
	{ timeout = 2,  widget = redflat.gauge.monitor.double, monitor = { icon = sysmon.icon.cpuram } }
)

sysmon.buttons.cpuram = awful.util.table.join(
	awful.button({ }, 1, function() redflat.float.top:show("cpu") end)
)


-- Screen setup
-----------------------------------------------------------------------------------------------------------------------

-- aliases for setup
local al = awful.layout.layouts

--  1: Floating
--  2: Grid
--  3: Right Tile
--  4: Left Tile
--  5: Fair Tile
--  6: User Map
--  7: Maximized
--  8: Fullscreen
--  9: Bottom Tile
-- 10: Top Tile

-- setup
-- TOOD: this is called per screen, maybe add some customization per individual screen (also check if 4 screens are connected, if not don't do anything special)
awful.screen.connect_for_each_screen(
	function(s)
		-- wallpaper
		env.wallpaper(s)

		if screen:count() ~= 4 then
			awful.tag({ "一", "二", "三", "四", "五" }, s, { al[6], al[7], al[7], al[5], al[3] })
		else

			if		 s.index == 2	then -- right vertical
				awful.tag({ "一", "二", "三" }, s, { al[9], al[7], al[6] })
			elseif s.index == 3 then -- left vertical
				awful.tag({ "一", "二", "三" }, s, { al[9], al[7], al[6] })
			elseif s.index == 4 then -- left horizontal
				awful.tag({ "一", "二", "三", "四", "五" }, s, { al[6], al[7], al[7], al[5], al[4] })
			elseif s.index == 1 then -- right horizontal
				awful.tag({ "一", "二", "三", "四", "五" }, s, { al[6], al[5], al[7], al[7], al[3] })
			end
		end

		-- layoutbox widget
		layoutbox[s] = redflat.widget.layoutbox({ screen = s })

		-- taglist widget
		taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

		-- tasklist widget
		tasklist[s] = redflat.widget.tasklist({ screen = s, buttons = tasklist.buttons }, tasklist.style)

		-- panel wibox
		s.panel = awful.wibar({ position = "top", screen = s, height = beautiful.panel_height or 36, bg = beautiful.bg_normal .. "20" })

		local left_widgets = {
			layout = wibox.layout.fixed.horizontal,
			env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
			separator,
			env.wrapper(taglist[s], "taglist"),
		}

		local middle_widget = {
			layout = wibox.layout.align.horizontal,
			expand = "outside",
			nil,
			env.wrapper(tasklist[s], "tasklist"),
		}

		local right_widgets = {}

		if screen:count() ~= 4 then
			right_widgets = {
				layout = wibox.layout.fixed.horizontal,
				env.wrapper(sysmon.widget.network, "network"),
				env.wrapper(sysmon.widget.cpuram, "cpuram", sysmon.buttons.cpuram),
				env.wrapper(volume.widget, "volume", volume.buttons),
				env.wrapper(tray.widget, "tray", tray.buttons),
				env.wrapper(textclock.widget, "textclock", textclock.buttons),
			}
		else

			if 	   s.index == 2 then -- right vertical
				right_widgets = {
					layout = wibox.layout.fixed.horizontal,
					env.wrapper(volume.widget, "volume", volume.buttons),
					env.wrapper(tray.widget, "tray", tray.buttons),
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				}
			elseif s.index == 3 then -- left vertical
				right_widgets = {
					layout = wibox.layout.fixed.horizontal,
					env.wrapper(volume.widget, "volume", volume.buttons),
					env.wrapper(tray.widget, "tray", tray.buttons),
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				}
			elseif s.index == 4 then -- right horizontal
				right_widgets = {
					layout = wibox.layout.fixed.horizontal,
					env.wrapper(sysmon.widget.network, "network"),
					env.wrapper(sysmon.widget.cpuram, "cpuram", sysmon.buttons.cpuram),
					env.wrapper(volume.widget, "volume", volume.buttons),
					env.wrapper(tray.widget, "tray", tray.buttons),
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				}
			elseif s.index == 1 then -- left horizontal
				right_widgets = {
					layout = wibox.layout.fixed.horizontal,
					env.wrapper(sysmon.widget.network, "network"),
					env.wrapper(sysmon.widget.cpuram, "cpuram", sysmon.buttons.cpuram),
					env.wrapper(volume.widget, "volume", volume.buttons),
					env.wrapper(tray.widget, "tray", tray.buttons),
					env.wrapper(textclock.widget, "textclock", textclock.buttons),
				}
			end
		end

		-- add widgets to the wibox
		s.panel:setup {
			layout = wibox.layout.align.horizontal,
			left_widgets,
			middle_widget,
			right_widgets,
		}
	end
)


-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
if not lock.desktop then
	local desktop = require("color.blue.desktop-config") -- load file with desktop widgets configuration
	desktop:init({
		env = env,
		buttons = awful.util.table.join(awful.button({}, 3, function () mymenu.mainmenu:toggle() end))
	})
end


-- Active screen edges
-----------------------------------------------------------------------------------------------------------------------
local edges = require("color.blue.edges-config") -- load file with edges configuration
edges:init()


-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local appkeys = require("color.blue.appkeys-config") -- load file with application keys sheet

local hotkeys = require("color.blue.keys-config") -- load file with hotkeys configuration
hotkeys:init({ env = env, menu = mymenu.mainmenu, appkeys = appkeys, volume = volume.widget })


-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require("color.blue.rules-config") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})


-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require("colorless.titlebar-config") -- load file with titlebar configuration
titlebar:init()


-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require("colorless.signals-config") -- load file with signals configuration
signals:init({ env = env })


-- Autostart user applications
-----------------------------------------------------------------------------------------------------------------------
if redflat.startup.is_startup then
	local autostart = require("color.blue.autostart-config") -- load file with autostart application list
	autostart.run()
end
