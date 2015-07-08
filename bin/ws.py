#!/usr/bin/env python

import gtk, webkit, sys

if len(sys.argv) <= 1 :
     print "Usage:", sys.argv[0], "'http://domain.com'"
     sys.exit(0)

gtk.rc_parse_string("""style "hide-scrollbar-style"
{
  GtkScrollbar::slider_width = 0
  GtkScrollbar::min-slider-length = 0
  GtkScrollbar::activate_slider = 0
  GtkScrollbar::trough_border = 0
  GtkScrollbar::has-forward-stepper = 0
  GtkScrollbar::has-backward-stepper = 0
  GtkScrollbar::stepper_size = 0
  GtkScrollbar::stepper_spacing = 0
  GtkScrollbar::trough-side-details = 0
  GtkScrollbar::default_border = { 0, 0, 0, 0 }
  GtkScrollbar::default_outside_border = { 0, 0, 0, 0 }
  GtkScrolledWindow::scrollbar-spacing = 0
  GtkScrolledWindow::scrollbar-within-bevel = False
}
widget_class "*Scrollbar" style "hide-scrollbar-style"
widget_class "*ScrolledWindow" style "hide-scrollbar-style"
""")

def browser_title_changed(widget, frame, title):
    win.set_title(title)

browser = webkit.WebView()

browser.connect('title-changed', browser_title_changed)

sw = gtk.ScrolledWindow()
sw.add(browser)
sw.set_policy(gtk.POLICY_ALWAYS, gtk.POLICY_ALWAYS)

win = gtk.Window(gtk.WINDOW_TOPLEVEL)
win.add(sw)
win.set_default_size(200, 400)
win.show_all()

browser.open(sys.argv[1])

gtk.main()
