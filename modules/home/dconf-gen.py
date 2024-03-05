#! /usr/bin/env python3

import subprocess
import configparser
import os

def get_dconf_dump():
    output = subprocess.check_output(['dconf', 'dump', '/']).decode('utf-8')
    
    # Parse the output as an INI format
    config = configparser.ConfigParser()
    config.read_string(output)
    return config

def save_dconf_nix(config):
    dir = os.path.dirname(os.path.abspath(__file__))
    with open(f'{dir}/dconf.ini', 'w') as f:
        config.write(f, space_around_delimiters=False)

    subprocess.run(['dconf2nix', '-i', 'dconf.ini', '-o', 'dconf.nix'], cwd=dir)

if __name__ == '__main__':
    filter = {
        "": False,
        "org/gnome/desktop/interface": ['!', 'color-scheme', 'gtk-theme', 'icon-theme'],
        "org/gnome/desktop/peripherals/touchpad": True,
        "org/gnome/desktop/wm/preferences": True,
        "org/gnome/shell": ["enabled-extensions", "favorite-apps"],
        "org/gnome/shell/keybindings": True,
        "org/gnome/desktop/wm/keybindings": True,
        "org/gnome/settings-daemon/plugins/media-keys": True,
        "org/gnome/shell/extensions": False,
        "org/gnome/shell/extensions/caffeine": ["restore-state"],
        "org/gnome/shell/extensions/just-perfection": True,
        "org/gnome/shell/extensions/nightthemeswitcher": True,
        "org/gnome/shell/extensions/nightthemeswitcher/time": ["manual-schedule", "nightthemeswitcher-ondemand-keybinding"],
        "org/gnome/shell/extensions/clipboard-indicator": True,
        "org/gnome/shell/extensions/gestureImprovements": True,
        "org/gnome/shell/extensions/tiling-assistant": ['!', 'overridden-settings'],
        "org/gnome/shell/extensions/astra-monitor": True,
        "org/gnome/system/location": True,
        "org/gnome/terminal/legacy": ['!', 'overridden-settings'],
        "com/github/amezin/ddterm": True,
        "org/gnome/desktop/input-sources": True,
    }

    config = get_dconf_dump()
    filtered_config = configparser.ConfigParser()

    for sec in config:
        if sec not in filter:
            prefixs = sec.split('/')
            while prefixs and '/'.join(prefixs) not in filter:
                prefixs.pop()
            key_filter = filter['/'.join(prefixs)]
        else:
            key_filter = filter[sec]

        key_filter_fn = lambda x: False
        if type(key_filter) == list:
            if key_filter:
                if key_filter[0] == '!':
                    key_filter_fn = lambda x: x not in key_filter
                else:
                    key_filter_fn = lambda x: x in key_filter
        elif key_filter:
            key_filter_fn = lambda x: True

        attributes = {}
        for key in config[sec]:
            if key_filter_fn(key):
                attributes[key] = config[sec][key]
        if attributes:
            filtered_config[sec] = attributes
                    
    save_dconf_nix(filtered_config)

