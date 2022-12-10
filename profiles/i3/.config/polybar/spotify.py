#!/usr/bin/python2

import dbus
from sys import argv

if len(argv) > 1:
    fmt = argv[1]
else:
    fmt = None

def format_output(artist, title, fmt=None):
    if fmt is None:
        fmt =  "{artist} - {title}"
    return fmt.format(artist=artist, title=title)
        

try:
    bus = dbus.SessionBus()
    spotify = bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
    spotify_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
    props = spotify_iface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
    try: 
        out = format_output((props['xesam:artist'][0]), str(props['xesam:title']), fmt)
    except IndexError:
        out = ''
    print(out)
    exit
except dbus.exceptions.DBusException:
    exit
