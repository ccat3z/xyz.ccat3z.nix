#! /usr/bin/env python3

import subprocess
import configparser
import io

def get_dconf_dump():
    output = subprocess.check_output(['dconf', 'dump', '/']).decode('utf-8')
    
    # Parse the output as an INI format
    config = configparser.ConfigParser()
    config.read_string(output)
    return config

def save_dconf_nix(config):
    with open('dconf.nix', 'w') as outfile:
        p = subprocess.Popen(['dconf2nix'], stdin=subprocess.PIPE, stdout=outfile, encoding='utf-8')
        config.write(p.stdin, space_around_delimiters=False)
        p.stdin.close()
        p.wait()

if __name__ == '__main__':
    filter = {
        "": False,
        "org/gnome/desktop/interface": True,
        "org/gnome/desktop/peripherals/touchpad": True,
        "org/gnome/desktop/wm/preferences": True,
        "org/gnome/shell": True,
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

