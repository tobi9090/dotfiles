pcall(require, "luarocks.loader")

local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

client.connect_signal("manage", function(c)
	c.shape = gears.shape.rounded_rect
end)

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- {{{ Variable definitions
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/night/theme.lua")
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
-- }}}

F = {}

-- {{{ Tag layout
require("config.layout")
-- }}}

-- {{{ Wibar
require("ui.bar")
-- }}}

-- {{{ Key bindings
require("config.keybindings")
-- }}}

-- {{{ Rules
require("config.rule")
-- }}}

-- {{{ Notifications
require("ui.notifications")
-- }}}

awful.spawn.with_shell("picom")
awful.spawn.with_shell("nitrogen --restore")

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
