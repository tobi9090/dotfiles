--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup")
local logout_popup = require("lib/awesome-wm-widgets.logout-popup-widget.logout-popup")
require("awful.hotkeys_popup.keys")
local mytable       = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "urxvtd", "unclutter -root" }) -- comma-separated entries

-- {{{ Variable definitions

local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "kitty"
local editor       = os.getenv("EDITOR") or "nvim"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

awful.util.taglist_buttons = mytable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = mytable.join(
     awful.button({ }, 1, function(c)
         if c == client.focus then
             c.minimized = true
         else
             c:emit_signal("request::activate", "tasklist", { raise = true })
         end
     end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow/theme.lua")

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}


-- {{{ Key bindings

globalkeys = mytable.join(
-- Launch Terminal (Wezterm)
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	-- Show run prompt ( Rofi )
	awful.key({ modkey }, "r", function()
		awful.util.spawn("rofi -show drun")
	end, { description = "run prompt", group = "launcher" }),

	-- Show hotkeys
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show hotkeys", group = "awesome" }),

	-- Restart Awesome
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	-- Quit/logout Awesome
	awful.key({ modkey, "Shift" }, "q", function()
		logout_popup.launch({
			bg_color = "#282a36",
			accent_color = "#ff79c6",
			phrases = { "Goodbye!!" },
		})
	end, { description = "Show logout screen", group = "awesome" }),

	-- Volume Control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("pamixer -i 5")
	end, { description = "increase volume", group = "control" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("pamixer -d 5")
	end, { description = "decrease volume", group = "control" }),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn("pamixer -t")
	end, { description = "mute volume", group = "control" }),

 -- Switch to the previous tag
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	-- Switch to the next tag
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	-- Go back to the tag
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ modkey, "Control" }, "Left", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ modkey, "Control" }, "Right", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:activate({ raise = true, context = "key.unminimize" })
		end
	end, { description = "restore minimized", group = "client" }),
	
	
	-- Layout related keybindings

	awful.key({ modkey, altkey }, "Left", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modkey, altkey }, "Right", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	
	awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key({ modkey }, "1", function()
		local screen = awful.screen.focused()
            local tag = screen.tags[1]
            if tag then
                tag:view_only()
            end
	end, { description = "only view tag 1", group = "tag" }),

     awful.key({ modkey }, "2", function()
		local screen = awful.screen.focused()
            local tag = screen.tags[2]
            if tag then
                tag:view_only()
            end
	end, { description = "only view tag 2", group = "tag" }),
     awful.key({ modkey }, "3", function()
		local screen = awful.screen.focused()
            local tag = screen.tags[3]
            if tag then
                tag:view_only()
            end
	end, { description = "only view tag 3", group = "tag" }),
     awful.key({ modkey }, "4", function()
		local screen = awful.screen.focused()
            local tag = screen.tags[4]
            if tag then
                tag:view_only()
            end
	end, { description = "only view tag 4", group = "tag" }),
     awful.key({ modkey }, "5", function()
		local screen = awful.screen.focused()
            local tag = screen.tags[5]
            if tag then
                tag:view_only()
            end
	end, { description = "only view tag 5", group = "tag" }),

    awful.key({ modkey, "Shift" }, "1", function()
		if client.focus then
				local tag = client.focus.screen.tags[1]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
	end, { description = "move focused client to tag 1", group = "tag" }),

    awful.key({ modkey, "Shift" }, "2", function()
		if client.focus then
				local tag = client.focus.screen.tags[2]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
	end, { description = "move focused client to tag 2", group = "tag" }),

    awful.key({ modkey, "Shift" }, "3", function()
		if client.focus then
				local tag = client.focus.screen.tags[3]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
	end, { description = "move focused client to tag 3", group = "tag" }),

    awful.key({ modkey, "Shift" }, "4", function()
		if client.focus then
				local tag = client.focus.screen.tags[4]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
	end, { description = "move focused client to tag 4", group = "tag" }),

    awful.key({ modkey, "Shift" }, "5", function()
		if client.focus then
				local tag = client.focus.screen.tags[5]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
	end, { description = "move focused client to tag 5", group = "tag" }),

	awful.key({
		modifiers = { modkey, "Shift" },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),

	awful.key({ modkey, "Shift" }, "Right", function()
		local select_tag = awful.screen.focused().selected_tag
		local tag = client.focus.screen.tags[select_tag.index + 1]
		if tag then
			client.focus:move_to_tag(tag)
		end
	end, { description = "move focused client to next tag", group = "tag" }),

	awful.key({ modkey, "Shift" }, "Left", function()
		local select_tag = awful.screen.focused().selected_tag
		local tag = client.focus.screen.tags[select_tag.index - 1]
		if tag then
			client.focus:move_to_tag(tag)
		end
	end, { description = "move focused client to previous tag", group = "tag" }),

	awful.key({
		modifiers = { modkey, "Control" },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	})
)

clientkeys = mytable.join(
   awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),

		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close window", group = "client" }),

		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, { description = "move to screen", group = "client" }),

		awful.key({ modkey }, "n", function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end, { description = "minimize", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),
		awful.key({ modkey, "Control" }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(un)maximize vertically", group = "client" }),
		awful.key({ modkey, "Shift" }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(un)maximize horizontally", group = "client" })
)

clientbuttons = mytable.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     callback = awful.client.setslave,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
c.shape = gears.shape.rounded_rect
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- AutoRun on startup
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nitrogen --restore")

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}
