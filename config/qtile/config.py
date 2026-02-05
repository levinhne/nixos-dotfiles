# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os

import libqtile.resources
from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen

# from libqtile.layout import columns, max, tree, xmonad
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from widgets.clock import MouseOverClock

colors = {
    "base00": "#282936",
    "base01": "#3a3c4e",
    "base02": "#4d4f68",
    "base03": "#626483",
    "base04": "#62d6e8",
    "base05": "#e9e9f4",
    "base06": "#f1f2f8",
    "base07": "#f7f7fb",
    "base08": "#ea51b2",
    "base09": "#b45bcf",
    "base0A": "#00f769",
    "base0B": "#ebff87",
    "base0C": "#a1efe4",
    "base0D": "#62d6e8",
    "base0E": "#b45bcf",
    "base0F": "#00f769",
}

mod = "mod4"
terminal = guess_terminal("kitty")
dmenu = "dmenu -c -h 35"
dmenu_run = "dmenu_run -c -h 35"
maim = "maim -s | xclip -selection clipboard -t image/png"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Key(
    #     [mod],
    #     "r",
    #     lazy.run_extension(
    #         extension.DmenuRun(
    #             dmenu_command=dmenu_run,
    #             dmenu_prompt=" ",
    #             dmenu_font="Iosevka Nerd Font:size=10",
    #         )
    #     ),
    # ),
    Key(
        [
            mod,
            "shift",
        ],
        "x",
        lazy.run_extension(
            extension.CommandSet(
                dmenu_command=dmenu,
                dmenu_prompt=" ",
                dmenu_font="Iosevka Nerd Font:size=10",
                commands={
                    "Lock screen": "slock",
                    "Reboot": "sudo systemctl reboot",
                    "Shutdown": "sudo systemctl poweroff",
                },
            )
        ),
        desc="",
    ),
    Key([mod], "s", lazy.spawn(maim, shell=True)),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(f"{i + 1}", label="") for i in range(8)]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_config = dict(
    margin=5,
    border_width=2,
    border_focus=colors["base08"],
    border_normal=colors["base02"],
)

max_layout_config = layout_config.copy()

max_layout_config.update({"border_width": 0})

layouts = [
    layout.Columns(**layout_config),
    layout.Max(**max_layout_config),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(
    #     num_stacks=2,
    # ),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    layout.Tile(**layout_config),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Spiral(),
]

widget_defaults = dict(
    font="Iosevka Nerd Font SemiBold",
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=5),
                widget.CurrentLayout(
                    foreground=colors["base05"],
                    mode="icon",
                    scale=0.7
                ),
                widget.Spacer(length=5),
                widget.GroupBox(
                    highlight_method="text",          # chỉ highlight text
                    borderwidth=2,
                    rounded=True,
                    foreground=colors["base05"],      # text mặc định
                    highlight_color=colors["base01"], # nền khi focus text
                    active=colors["base06"],          # group đang có window
                    inactive=colors["base03"],        # group trống
                    this_current_screen_border=colors["base09"],  # group hiện tại (screen hiện tại)
                    this_screen_border=colors["base02"],          # group hiện tại (screen khác)
                    urgent_border=colors["base08"],   # urgent (hồng đậm)
                    disable_drag=True,
                    fontsize=26,
                ),
                widget.Spacer(length=5),
                widget.Prompt(),
                widget.Spacer(length=5),
                widget.WindowName(
                    max_chars=50,
                    foreground=colors["base05"],
                ),
                widget.TextBox(
                    text="",
                    foreground=colors["base05"],
                ),
                widget.Spacer(length=2),
                widget.Volume(
                    limit_max_volume=True,
                    fmt="{}",
                    foreground=colors["base05"],
                ),
                widget.Spacer(length=10),
                widget.TextBox(
                    text="󰤨 ",
                    foreground=colors["base05"],
                ),
                widget.Net(
                    format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
                    foreground=colors["base05"],
                ),
                widget.Spacer(length=10),
                widget.TextBox(
                    text=" ",
                    foreground=colors["base05"],
                ),
                widget.CPU(
                    format="{freq_current}GHz {load_percent}%",
                    foreground=colors["base05"],
                ),
                widget.Spacer(length=10),
                widget.TextBox(
                    text=" ",
                    foreground=colors["base05"],
                ),
                widget.Memory(
                    format="{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}",
                    foreground=colors["base05"],
                ),
                widget.TextBox(
                    text=" ",
                    foreground=colors["base05"],
                ),
                MouseOverClock(
                    format="%I:%M %p",
                    long_format="%Y-%m-%d %I:%M %p",
                    foreground=colors["base05"],
                ),
                # widget.Spacer(length=10),
                # widget.Redshift(),
                widget.Spacer(length=5),
            ],
            30,
            background=colors["base00"],
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # wallpaper=os.path.expanduser("~/.wallpapers/backgroud-1.jpg"),
        # wallpaper_mode="center",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_width=2,
    border_focus=colors["base08"],
    border_normal=colors["base02"],
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="lxappearance"),  # Screenshot utility
        Match(wm_class="mpv"),
        Match(wm_class="pinentry-gtk"),
        Match(wm_class="VirtualBox Manager"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_size = 20

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
