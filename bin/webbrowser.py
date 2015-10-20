#!/usr/bin/python2

import gtk, webkit

def go_but(widget):
	add = addressbar.get_text()
	web.open(add)

win = gtk.Window()
win.connect('destroy', lambda w: gtk.main_quit())

vbox = gtk.VBox()
win.add(vbox)

hbox = gtk.HBox()
vbox.pack_start(hbox, False)

addressbar = gtk.Entry()
hbox.pack_start(addressbar)

gobutton = gtk.Button("GO")
hbox.pack_start(gobutton)
gobutton.connect('clicked', go_but)

scroller = gtk.ScrolledWindow()
vbox.pack_start(scroller)

web = webkit.WebView()
scroller.add(web)

win.show_all()

gtk.main()








