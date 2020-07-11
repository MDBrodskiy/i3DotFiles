#!/usr/bin/env python3

import pyudev
import subprocess

# def main():
    # context = pyudev.Context()
    # monitor = pyudev.Monitor.from_netlink(context)
    # monitor.filter_by(subsystem='usb')
    # monitor.start()

    # for device in iter(monitor.poll, None):
        # # I can add more logic here, to run different scripts for different devices.
        # subprocess.call(['/home/Devuan/.config/polybar/scripts/usbmount'])

# if __name__ == '__main__':
    # main()

context = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(context)
monitor.filter_by(subsystem='usb')

for device in iter(monitor.poll, None):
    if device.action == 'add':
        print('{} connected'.format(device))
        subprocess.call(['/home/Devuan/.config/polybar/scripts/usbmount'])

