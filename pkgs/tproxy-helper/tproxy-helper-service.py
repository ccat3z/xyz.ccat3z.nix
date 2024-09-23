#! /usr/bin/env python3

import os
os.environ["GI_TYPELIB_PATH"] = "@GI_TYPELIB_PATH@"

import json
from textwrap import dedent
import dbus
import dbus.service
import subprocess
from gi.repository import GLib
from dbus.mainloop.glib import DBusGMainLoop

BUS_NAME = 'xyz.ccat3z.TProxyHelper'
OBJECT_PATH = '/xyz/ccat3z/tproxy_helper'


def get_cgroup(pid):
  with open(f'/proc/{pid}/cgroup', 'r') as f:
     # https://man7.org/linux/man-pages/man7/cgroups.7.html
     [hierarchy_id, controller_list, cgroup_path] = f.read().split(':')
     return cgroup_path.removeprefix('/').strip()


def nft_list_handlers():
    res = subprocess.run(
        ['@nft@', '-a', '--json', 'list', 'chain', 'inet', 'proxy_skip', 'prerouting'],
        capture_output=True
    )

    if res.returncode != 0:
      stderr = res.stderr.decode()
      if 'No such file or directory' in stderr:
        return []

      raise Exception(f"nft exited with {res.returncode}:\n{stderr}")

    handlers = []

    for result in json.loads(res.stdout).get("nftables", []):
      if "rule" not in result:
        continue

      rule = result["rule"]
      for expr in rule["expr"]:
        if "match" not in expr:
          continue

        expr_match = expr["match"]
        assert(expr_match["op"] == "==")
        assert(expr_match["left"]["socket"]["key"] == "cgroupv2")

        handlers.append((rule["handle"], expr_match["right"]))
        break

    return handlers


class TProxyHelperService(dbus.service.Object):
  def __init__(self, bus_name):
    self.bus_name = bus_name
    dbus.service.Object.__init__(self, bus_name, OBJECT_PATH)

  @dbus.service.method(BUS_NAME, in_signature='', out_signature='', sender_keyword='sender')
  def bypass_sender_cgroup(self, sender):
    self.clean()

    sender_pid = self.get_connection_unix_process_id(sender)
    cgroup = get_cgroup(sender_pid)

    print(f"Bypass pid {sender_pid} cgroup {cgroup}")
    subprocess.run(
        ['@nft@', '-f', '-'],
        input=dedent("""
          table inet proxy_skip
          table inet proxy_skip {{
            chain prerouting {{
              type route hook output priority mangle - 1
              policy accept
              socket cgroupv2 level {} "{}" meta mark set 0xff
            }}
          }}
        """).format(len(cgroup.split('/')), cgroup).encode('utf-8'),
        check=True
    )

  @dbus.service.method(BUS_NAME, in_signature='', out_signature='')
  def clean(self):
    for handle, cgroup in nft_list_handlers():
      if cgroup.isdigit():
        print(f"Remove rule for {cgroup}")
        subprocess.run(
            ['@nft@', 'delete', 'rule', 'inet', 'proxy_skip', 'prerouting', 'handle', str(handle)],
            check=True
        )

  def get_connection_unix_process_id(self, connection_name):
    try:
      dbus_proxy = self.bus_name.get_bus().get_object('org.freedesktop.DBus', '/org/freedesktop/DBus')
      dbus_interface = dbus.Interface(dbus_proxy, 'org.freedesktop.DBus')
      pid = dbus_interface.GetConnectionUnixProcessID(connection_name)
      return pid
    except Exception as e:
      raise Exception("failed to get sender pid", e)


def main():
    DBusGMainLoop(set_as_default=True)
    bus_name = dbus.service.BusName(BUS_NAME, dbus.SystemBus())
    TProxyHelperService(bus_name)
    print(f"{BUS_NAME} service is running.")

    loop = GLib.MainLoop()
    loop.run()


if __name__ == '__main__':
    main()
