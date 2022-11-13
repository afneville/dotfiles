pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local scheme = xresources.get_current_theme()

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")
require("awful.autofocus")

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
}

launcher_widget = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

clock_widget = wibox.widget.textclock("%d/%m/%Y %H:%M ")

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                )

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    s.taglist_widget = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    s.top_bar = awful.wibar({ position = "top", screen = s })

    s.top_bar:setup {
        layout = wibox.layout.align.horizontal,
        { -- left section
            layout = wibox.layout.fixed.horizontal,
            launcher_widget,
            s.taglist_widget,
        },
        { -- middle section
            layout = wibox.layout.fixed.horizontal,
        },
        { -- right section
            layout = wibox.layout.fixed.horizontal,
            clock_widget,
        },
    }
end)

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "r",      awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit, {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "j",      function () awful.client.focus.byidx( 1)        end, {description = "focus next by index", group = "client"}),
    awful.key({ modkey,           }, "k",      function () awful.client.focus.byidx(-1)        end, {description = "focus previous by index", group = "client"}),
    awful.key({ modkey,           }, "w",      function () mymainmenu:show()                   end, {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "j",      function () awful.client.swap.byidx(  1)        end, {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k",      function () awful.client.swap.byidx( -1)        end, {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j",      function () awful.screen.focus_relative( 1)     end, {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k",      function () awful.screen.focus_relative(-1)     end, {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal)               end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact( 0.05)          end, {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(-0.05)          end, {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1, nil, true) end, {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1, nil, true) end, {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1, nil, true)    end, {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1, nil, true)    end, {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc( 1)                end, {description = "select next", group = "layout"}),
    awful.key({ modkey,           }, "p",      function() menubar.show()                       end, {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                                                  , {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen c:raise()                     end, {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                                                      end, {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())                              end, {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()                                            end, {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop                                         end, {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = true                                            end, {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",      function (c) c.maximized = not c.maximized c:raise()                       end, {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",      function (c) c.maximized_vertical = not c.maximized_vertical c:raise()     end, {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",      function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end, {description = "(un)maximize horizontally", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
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

root.keys(globalkeys)

awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

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

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

}

client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            -- buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            -- { -- Title
            --     align  = "center",
            --     widget = awful.titlebar.widget.titlewidget(c)
            -- },
            -- buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
