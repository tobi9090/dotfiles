-- Library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local logout_popup = require("lib/awesome-wm-widgets.logout-popup-widget.logout-popup")
-- require("awful.hotkeys_popup.keys")

-- Normal applicants etc hotkeys
awful.keyboard.append_global_keybindings({

	-- Launch Terminal (Alacritty)
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
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({

	-- Switch to the previous tag
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	-- Switch to the next tag
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	-- Go back to the tag
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({

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
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, "Mod1" }, "Left", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modkey, "Mod1" }, "Right", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
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
	}),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
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
		end, { description = "(un)maximize horizontally", group = "client" }),
	})
end)
