#!/bin/sh
# Reads the todo file and emits conky markup.

FILE="$HOME/.local/share/todo/todo.txt"
MAXLEN=32

printf '${color1}${font JetBrainsMono Nerd Font:bold:size=11}TODO${font}${color}'

if [ ! -f "$FILE" ]; then
    printf '\n${color3}no list yet${color}\n'
    exit 0
fi

open=$(grep -c '^\[ \]' "$FILE" 2>/dev/null || true)
[ -z "$open" ] && open=0

printf '${alignr}${color3}%s open${color}\n' "$open"
printf '${color3}${hr 1}${color}\n'

awk -v max="$MAXLEN" '
    /^\[ \]/ {
        t = substr($0, 5)
        if (length(t) > max) t = substr(t, 1, max - 1) "..."
        printf "${color2}\xe2\x96\xaa${color} %s\n", t
        n++
        next
    }
    /^\[x\]/ {
        t = substr($0, 5)
        if (length(t) > max) t = substr(t, 1, max - 1) "..."
        printf "${color3}\xe2\x9c\x93 %s${color}\n", t
        next
    }
    /^[[:space:]]*$/ { next }
    {
        t = $0
        if (length(t) > max) t = substr(t, 1, max - 1) "..."
        printf "${color3}  %s${color}\n", t
    }
    END { if (n == 0) print "${color3}nothing pending${color}" }
' "$FILE"
