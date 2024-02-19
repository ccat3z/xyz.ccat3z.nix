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
        "org/gnome/desktop/interface": True,
        "org/gnome/desktop/peripherals/touchpad": True,
        "org/gnome/desktop/wm/preferences": True,
        "org/gnome/shell": ["enabled-extensions", "favorite-apps"],
        "org/gnome/shell/extensions": False,
        "org/gnome/shell/extensions/caffeine": True,
        "org/gnome/shell/extensions/just-perfection": True,
        "org/gnome/shell/extensions/nightthemeswitcher": True,
        "org/gnome/shell/extensions/nightthemeswitcher/time": ["manual-schedule", "nightthemeswitcher-ondemand-keybinding"],
        "org/gnome/system/location": True,
        "org/gnome/terminal/legacy": True,
    }

    config = get_dconf_dump()
    filtered_config = configparser.ConfigParser()

    for sec in config:
        if sec not in filter:
            prefixs = sec.split('/')
            while prefixs and '/'.join(prefixs) not in filter:
                prefixs.pop()
            attributes_filter = filter['/'.join(prefixs)]
        else:
            attributes_filter = filter[sec]

        if type(attributes_filter) == list:
            attributes = {}
            for key in config[sec]:
                if key in attributes_filter:
                    attributes[key] = config[sec][key]
            if attributes:
                filtered_config[sec] = attributes
        elif attributes_filter:
            filtered_config[sec] = config[sec]
                    
    save_dconf_nix(filtered_config)

