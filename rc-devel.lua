-----------------------------------------------------------------------------------------------------------------------
--                                              Development setup                                                    --
-----------------------------------------------------------------------------------------------------------------------

-- Disable some config parts
--------------------------------------------------------------------------------
lock = {} -- global
lock.desktop = false
lock.autostart = true

-- Configuration file selection
--------------------------------------------------------------------------------
--local rc = "colorless.rc-colorless"

--local rc = "color.blue.rc-blue"

local rc = "shade.ruby.rc-ruby"

require(rc)

-- DPI setup
--------------------------------------------------------------------------------
local beautiful = require("beautiful")
beautiful.xresources.set_dpi(96, 1)
