#!/usr/bin/env python
import gtk, webkit, sys

if len(sys.argv) <= 1 :
     print "Usage:", sys.argv[0], "url"
     sys.exit(0)

win = gtk.Window()
win.connect('destroy', lambda w: gtk.main_quit())
vbox = gtk.VBox()
win.add(vbox)
hbox = gtk.HBox()
vbox.pack_start(hbox, False)
scroller = gtk.ScrolledWindow()
vbox.pack_start(scroller)
web = webkit.WebView()
scroller.add(web)
win.show_all()
web.open(sys.argv[1])
win.fullscreen()
gtk.main()








