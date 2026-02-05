import sys
import os

config.load_autoconfig(False)

# Tabs stylisées et plus visibles
c.tabs.padding = {"top": 5, "bottom": 5, "left": 10, "right": 10}
c.tabs.indicator.width = 0
c.window.transparent = True

c.colors.webpage.darkmode.enabled = False

dark_sites = [
    'vnexpress.net'
]

for site in dark_sites:
    config.set('colors.webpage.darkmode.enabled', True, site)


# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "x": "quit --save",
}

# Keybindings

# Theme
config.source("themes/dracula.py")

# Adblock (ABP)
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

# Proxy Configuration
proxy_file = os.path.join(os.path.dirname(__file__), 'proxy.py')
if os.path.exists(proxy_file):
    sys.path.insert(0, os.path.dirname(__file__))
    try:
        from proxy import setup_proxy
        setup_proxy(config)
    except ImportError:
        pass  # Proxy configuration not available

config.bind('<z><l>', 'spawn --userscript qute-pass')
config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only')
config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')
