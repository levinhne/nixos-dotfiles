# qutebrowser config
# Docs: https://qutebrowser.org/doc/help/settings.html

config.load_autoconfig(False)

# Tabs
c.tabs.padding = {"top": 5, "bottom": 5, "left": 10, "right": 10}
c.tabs.indicator.width = 0
c.window.transparent = True
c.tabs.show = "switching"
c.tabs.background = True

# Dark mode: off by default, force-enabled on sites without a proper dark theme
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "auto"
dark_sites = [
    'vnexpress.net',
]
for site in dark_sites:
    config.set('colors.webpage.darkmode.enabled', True, site)

# General settings
c.editor.command = ["kitty", "-e", "nvim", "{file}", "-c", "normal {line}G{column0}l"]
c.downloads.location.directory = "~/Downloads"
c.zoom.default = "100%"
c.statusbar.show = "in-mode"
c.auto_save.session = True
c.url.auto_search = "naive"
c.completion.height = "33%"
c.downloads.position = "bottom"
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-US"]
c.confirm_quit = ["downloads"]

# File handling (using ranger)
config.set("fileselect.handler", "external")
config.set(
    "fileselect.single_file.command",
    ["kitty", "-e", "ranger", "--choosefile", "{}"],
)
config.set(
    "fileselect.multiple_files.command",
    ["kitty", "-e", "ranger", "--choosefiles", "{}"],
)

# Content
c.content.pdfjs = True
c.content.autoplay = False

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "gg": "https://google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "nw": "https://nixos.wiki/index.php?search={}",
    "no": "https://search.nixos.org/packages?channel=unstable&query={}",
    "yt": "https://youtube.com/results?search_query={}",
    "rd": "https://reddit.com/search/?q={}",
}

# Per-site overrides normally kept in autoconfig.yml (disabled above)
config.set('content.notifications.enabled', True, 'https://www.youtube.com')

# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "x": "quit --save",
}

# Keybindings
leader = ","

config.bind("t", "cmd-set-text -s :open -t")
config.bind("O", "cmd-set-text -s :open -w")
config.bind("P", "cmd-set-text -s :open -p")
config.bind("W", "tab-clone -w")
config.bind("a", "mode-enter insert")

config.bind("K", "back")
config.bind("J", "forward")
config.bind("H", "tab-prev")
config.bind("L", "tab-next")
config.bind("Q", "tab-close")

config.bind("<Ctrl-=>", "zoom-in")
config.bind("<Ctrl-->", "zoom-out")

# Leader bindings
config.bind(leader + "b", "config-cycle statusbar.show always in-mode")
config.bind(leader + "B", "config-cycle tabs.show multiple switching")
config.bind(leader + "c", "config-edit")
config.bind(leader + "C", "cmd-set-text -s :set -t")
config.bind(leader + "d", "devtools")
config.bind(leader + "D", "devtools-focus")
config.bind(leader + "e", "edit-text")
config.bind(leader + "E", "cmd-edit")
config.bind(leader + "i", "hint inputs")
config.bind(leader + "h", "history")
config.bind(leader + "H", "help")
config.bind(leader + "m", "bookmark-list")
config.bind(leader + "M", "bookmark-add")
config.bind(leader + "n", "tab-clone")
config.bind(leader + "N", "tab-clone -w")
config.bind(leader + "o", "hint links window")
config.bind(leader + "O", "hint links run :open -p {hint-url}")
config.bind(leader + "p", "tab-pin")
config.bind(leader + "P", "cmd-set-text -s :tab-move")
config.bind(leader + "q", "tab-close")
config.bind(leader + "Q", "close")
config.bind(leader + "r", "config-source")
config.bind(leader + "R", "restart")
config.bind(leader + "s", "screenshot ~/Pictures/Screenshots/qute-{time}.png")
config.bind(leader + "S", "view-source --edit")
config.bind(leader + "t", "cmd-set-text -s :tab-select")
config.bind(leader + "T", "tab-only")
config.bind(leader + "u", "undo")
config.bind(leader + "v", "hint links spawn mpv {hint-url}")
config.bind(leader + "V", "hint links spawn kitty -e yt-dlp {hint-url}")
config.bind(leader + "w", "cmd-set-text -s :tab-take")
config.bind(leader + "W", "tab-give")
config.bind(leader + "y", "hint links yank")
config.bind(leader + "x", "quit --save")
config.bind(leader + "X", "window-only")

config.bind("p", "tab-pin")
config.bind(";w", "hint link spawn --detach mpv --force-window yes {hint-url}")
config.bind(";W", "spawn --detach mpv --force-window yes {url}")
config.bind(";I", "hint images spawn --output-message wget -P ~/Downloads/ -c {hint-url}")

# Theme
config.source("themes/dracula.py")

# Adblock (ABP-style lists)
c.content.blocking.method = "both"
c.content.blocking.enabled = True
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
]
