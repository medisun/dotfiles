; bind shift + vertical scroll to horizontal scroll events
(xbindkey '(shift "b:4") "xte 'mouseclick 6'")
(xbindkey '(shift "b:5") "xte 'mouseclick 7'")

; Volume
(xbindkey '(Mod4 "b:4") "amixer -D pulse sset Master 4%+")
(xbindkey '(Mod4 "b:5") "amixer -D pulse sset Master 4%-")

; Transparent
(xbindkey '(Mod1 Mod4 "b:4") "transset-df -a --inc 0.05")
(xbindkey '(Mod1 Mod4 "b:5") "transset-df -a --dec 0.05")
