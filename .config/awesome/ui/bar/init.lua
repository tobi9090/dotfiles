-- Library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Text clock
local time = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	{
		widget = wibox.widget.textclock("%a %d %b, %H:%M"),
		font = beautiful.font_name .. " Bold 11",
		align = "center",
	},
})

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(1)
			end),
		},
	})

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		style = {
			border_width = 1,
			shape = gears.shape.rounded_bar,
		},
		layout = wibox.layout.fixed.horizontal,

		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = 7,
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			forced_width = 600,
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	s.mywibar = awful.wibar({
		type = "dock",
		ontop = true,
		stretch = false,
		visible = true,
		height = dpi(39),
		bg = beautiful.bg_normal,
		opacity = 0.9,
		width = s.geometry.width - 20,
		shape = helpers.rrect(beautiful.border_radius),
		screen = s,
	})

	--	awful.placement.top(s.mywibar, { margins = beautiful.useless_gap * 1 })
	awful.placement.top(s.mywibar, { margins = { top = 10 } })

	s.mywibar:struts({
		top = dpi(45),
	})

	-- Remove wibar on full screen
	local function remove_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = false
		else
			c.screen.mywibar.visible = true
		end
	end

	-- Remove wibar on full screen
	local function add_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = true
		end
	end

	-- Hide bar when a splash widget is visible
	awesome.connect_signal("widgets::splash::visibility", function(vis)
		screen.primary.mywibar.visible = not vis
	end)

	client.connect_signal("property::fullscreen", remove_wibar)

	client.connect_signal("request::unmanage", add_wibar)

	-- Create the wibox
	s.mywibar:setup({
		{
			layout = wibox.layout.align.horizontal,
			{
				s.mytaglist,
				widget = wibox.container.margin,
			},
			{
				s.mytasklist,
				widget = wibox.container.place,
			},
			{ time, widget = wibox.container.margin },
		},
		left = dpi(15),
		right = dpi(15),
		widget = wibox.container.margin,
	})
end)
