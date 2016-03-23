; bind shift + vertical scroll to horizontal scroll events
(xbindkey '(shift "b:4") "xte 'mouseclick 6'")
(xbindkey '(shift "b:5") "xte 'mouseclick 7'")
; (xbindkey '("XF86Copy") "xte 'keydown Control_L' 'key Insert' 'keyup Control_L'")
; (xbindkey '("XF86Paste") "xte 'keydown Shift_L' 'key Insert' 'keyup Shift_L'")
; (xbindkey '("XF86Cut") "xte 'keydown Shift_L' 'key Delete' 'keyup Shift_L'")

; Volume
(xbindkey '(Mod4 "b:4") "amixer -D pulse sset Master 4%+")
(xbindkey '(Mod4 "b:5") "amixer -D pulse sset Master 4%-")

; Transparent
(xbindkey '(Mod1 Mod4 "b:4") "transset-df -a --inc 0.05")
(xbindkey '(Mod1 Mod4 "b:5") "transset-df -a --dec 0.05")

