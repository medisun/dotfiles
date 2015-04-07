Tips, tricks and hacks
======================


Shift+MouseWheel -> Horizontal Scroll
-------------------------------------

Install xbindkeys and xautomation. Edit ```~/.xbindkeysrc.scm``` and write:
```
; bind shift + vertical scroll to horizontal scroll events
(xbindkey '(shift "b:4") "xte 'mouseclick 6'")
(xbindkey '(shift "b:5") "xte 'mouseclick 7'")
```
Run xbindkeys


Firefox Horizontal Scroll & disable navigate  in history
--------------------------------------------------------
```
mousewheel.with_shift.action integer 1
mousewheel.with_shift.delta_multiplier_x integer 300
mousewheel.with_shift.delta_multiplier_y integer 300
mousewheel.with_shift.delta_multiplier_z integer 300
```