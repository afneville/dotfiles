config.load_autoconfig(False)

c.url.searchengines = {'DEFAULT': 'https://google.com/search?q={}', 'aw': 'https://wiki.archlinux.org/?search={}', 'wiki': 'https://en.wikipedia.org/wiki/{}', 'yt': 'https://www.youtube.com/results?search_query={}'}
c.zoom.default = "200%"
c.completion.shrink = True
c.completion.height = "50%"
c.downloads.location.directory = '~/tmp'
c.tabs.show = "never"
c.statusbar.show = "never"
c.url.default_page = 'https://alexneville.co.uk/start.html'
c.url.start_pages = 'https://alexneville.co.uk/start.html'
c.completion.open_categories = ["searchengines", "quickmarks", "bookmarks", "filesystem"]

c.fonts.default_family = '"Iosevka Nerd Font"'
c.fonts.default_size = '10pt'
c.fonts.completion.entry = '10pt "Jetbrains Mono Nerd Font"'
c.fonts.debug_console = '10pt "Jetbrains Mono Nerd Font"'
c.fonts.tabs.selected = '10pt "Jetbrains Mono Nerd Font"'
c.fonts.tabs.unselected = '10pt "Jetbrains Mono Nerd Font"'
c.fonts.prompts = 'default_size sans-serif'
c.fonts.statusbar = '11pt "Jetbrains Mono Nerd Font"'
c.fonts.hints = '9pt "Jetbrains Mono Nerd Font"'

# config.bind('<Tab>', 'tab-next')
# config.bind('<Shift+Tab>', 'tab-prev')
config.bind('D', 'tab-only')
config.bind('x', 'tab-close')
# config.bind('T', 'open -t')
# config.bind('rr', 'reload -f')
# config.bind('R', 'restart')
# config.bind('<Ctrl-j>', 'set-cmd-text -sr :tab-focus')
# config.bind('<Ctrl-k>', 'set-cmd-text -sr :tab-focus')
config.bind('tb', 'config-cycle statusbar.show always never')
config.bind('tt', 'config-cycle tabs.show always never')
config.bind('ta', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
config.bind('<Ctrl-j>', 'completion-item-focus next', mode="command")
config.bind('<Ctrl-k>', 'completion-item-focus prev', mode="command")


# colours
base00 = "#202020"
base01 = "#2a2827"
base02 = "#504945"
base03 = "#5a524c"
base04 = "#bdae93"
base05 = "#ddc7a1"
base06 = "#ebdbb2"
base07 = "#fbf1c7"
base08 = "#ea6962"
base09 = "#e78a4e"
base0A = "#d8a657"
base0B = "#a9b665"
base0C = "#89b482"
base0D = "#7daea3"
base0E = "#d3869b"
base0F = "#bd6f3e"
c.colors.completion.fg = base05
c.colors.completion.odd.bg = base00
c.colors.completion.even.bg = base00
c.colors.completion.category.fg = base0A
c.colors.completion.category.bg = base02
c.colors.completion.category.border.top = base00
c.colors.completion.category.border.bottom = base00
c.colors.completion.item.selected.fg = base05
c.colors.completion.item.selected.bg = base02
c.colors.completion.item.selected.border.top = base02
c.colors.completion.item.selected.border.bottom = base02
c.colors.completion.item.selected.match.fg = base0B
c.colors.completion.match.fg = base0B
c.colors.completion.scrollbar.fg = base05
c.colors.completion.scrollbar.bg = base00
c.colors.contextmenu.disabled.bg = base01
c.colors.contextmenu.disabled.fg = base04
c.colors.contextmenu.menu.bg = base00
c.colors.contextmenu.menu.fg =  base05
c.colors.contextmenu.selected.bg = base02
c.colors.contextmenu.selected.fg = base05
c.colors.downloads.bar.bg = base00
c.colors.downloads.start.fg = base00
c.colors.downloads.start.bg = base0D
c.colors.downloads.stop.fg = base00
c.colors.downloads.stop.bg = base0C
c.colors.downloads.error.fg = base08
c.colors.hints.fg = base00
c.colors.hints.bg = base0A
c.colors.hints.match.fg = base05
c.colors.keyhint.fg = base05
c.colors.keyhint.suffix.fg = base05
c.colors.keyhint.bg = base00
c.colors.messages.error.fg = base00
c.colors.messages.error.bg = base08
c.colors.messages.error.border = base08
c.colors.messages.warning.fg = base00
c.colors.messages.warning.bg = base0E
c.colors.messages.warning.border = base0E
c.colors.messages.info.fg = base05
c.colors.messages.info.bg = base00
c.colors.messages.info.border = base00
c.colors.prompts.fg = base05
c.colors.prompts.border = base00
c.colors.prompts.bg = base00
c.colors.prompts.selected.bg = base02
c.colors.prompts.selected.fg = base05
c.colors.statusbar.normal.fg = base0B
c.colors.statusbar.normal.bg = base02
c.colors.statusbar.insert.fg = base00
c.colors.statusbar.insert.bg = base0D
c.colors.statusbar.passthrough.fg = base00
c.colors.statusbar.passthrough.bg = base0C
c.colors.statusbar.private.fg = base00
c.colors.statusbar.private.bg = base01
c.colors.statusbar.command.fg = base05
c.colors.statusbar.command.bg = base02
c.colors.statusbar.command.private.fg = base05
c.colors.statusbar.command.private.bg = base00
c.colors.statusbar.caret.fg = base00
c.colors.statusbar.caret.bg = base0E
c.colors.statusbar.caret.selection.fg = base00
c.colors.statusbar.caret.selection.bg = base0D
c.colors.statusbar.progress.bg = base0D
c.colors.statusbar.url.fg = base05
c.colors.statusbar.url.error.fg = base08
c.colors.statusbar.url.hover.fg = base05
c.colors.statusbar.url.success.http.fg = base0C
c.colors.statusbar.url.success.https.fg = base0B
c.colors.statusbar.url.warn.fg = base0E
c.colors.tabs.bar.bg = base00
c.colors.tabs.indicator.start = base0D
c.colors.tabs.indicator.stop = base0C
c.colors.tabs.indicator.error = base08
c.colors.tabs.odd.fg = base05
c.colors.tabs.odd.bg = base01
c.colors.tabs.even.fg = base05
c.colors.tabs.even.bg = base00
c.colors.tabs.pinned.even.bg = base0C
c.colors.tabs.pinned.even.fg = base07
c.colors.tabs.pinned.odd.bg = base0B
c.colors.tabs.pinned.odd.fg = base07
c.colors.tabs.pinned.selected.even.bg = base02
c.colors.tabs.pinned.selected.even.fg = base05
c.colors.tabs.pinned.selected.odd.bg = base02
c.colors.tabs.pinned.selected.odd.fg = base05
c.colors.tabs.selected.odd.fg = base05
c.colors.tabs.selected.odd.bg = base02
c.colors.tabs.selected.even.fg = base05
c.colors.tabs.selected.even.bg = base02
