#!/usr/bin/env python3
import os
import sys
import signal
import gi
import cairo

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk

if len(sys.argv) < 5:
    print("usage: recording-border.py WIDTH HEIGHT THICKNESS PIDFILE [COLOR]")
    sys.exit(1)

WIDTH = int(sys.argv[1])
HEIGHT = int(sys.argv[2])
THICKNESS = int(sys.argv[3])
PIDFILE = sys.argv[4]
COLOR = sys.argv[5] if len(sys.argv) >= 6 else "ff5555ff"

if not COLOR.startswith("#"):
    COLOR = "#" + COLOR

with open(PIDFILE, "w") as f:
    f.write(str(os.getpid()))

rgba = Gdk.RGBA()
rgba.parse(COLOR)


class BorderWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="wf-recorder-region-border")

        self.set_decorated(False)
        self.set_app_paintable(True)
        self.set_accept_focus(False)
        self.set_focus_on_map(False)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)
        self.set_keep_above(True)
        self.set_default_size(WIDTH, HEIGHT)
        self.set_size_request(WIDTH, HEIGHT)

        visual = self.get_screen().get_rgba_visual()
        if visual:
            self.set_visual(visual)

        self.connect("draw", self.on_draw)
        self.connect("realize", self.on_realize)

    def on_realize(self, *_):
        window = self.get_window()
        if hasattr(window, "set_pass_through"):
            window.set_pass_through(True)

    def on_draw(self, _widget, cr):
        cr.set_operator(cairo.OPERATOR_SOURCE)
        cr.set_source_rgba(0, 0, 0, 0)
        cr.paint()

        cr.set_operator(cairo.OPERATOR_OVER)
        cr.set_source_rgba(rgba.red, rgba.green, rgba.blue, rgba.alpha)

        t = THICKNESS
        w = WIDTH
        h = HEIGHT

        cr.rectangle(0, 0, w, t)
        cr.rectangle(0, h - t, w, t)
        cr.rectangle(0, 0, t, h)
        cr.rectangle(w - t, 0, t, h)
        cr.fill()

        return False


def cleanup(*_):
    try:
        os.remove(PIDFILE)
    except FileNotFoundError:
        pass
    Gtk.main_quit()


signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

win = BorderWindow()
win.show_all()
Gtk.main()
cleanup()
