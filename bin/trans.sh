#!/bin/bash

#xclip -out | translit | xclip -in
#xclip -out -sel clip| translit | xclip -in -sel clip
xclip -out clip| translit | xclip -in -sel clip
