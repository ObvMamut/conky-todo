#!/bin/sh
set -eu
WIDGET_DIR="$HOME/.config/conky/todo"
DATA_DIR="$HOME/.local/share/todo"
BIN_DIR="$HOME/.local/bin"
BSPWMRC="$HOME/.config/bspwm/bspwmrc"
SXHKDRC="$HOME/.config/sxhkd/sxhkdrc"

pkill -f 'conky.*todo/todo.conf' >/dev/null 2>&1 || true

for f in "$BSPWMRC" "$SXHKDRC"; do
    [ -f "$f" ] || continue
    sed -i '/# >>> todo widget >>>/,/# <<< todo widget <<</d' "$f"
done
pkill -USR1 -x sxhkd >/dev/null 2>&1 || true

if [ -f "$DATA_DIR/todo.txt" ]; then
    cp "$DATA_DIR/todo.txt" "$HOME/todo_backup.txt"
    printf 'list saved to %s/todo_backup.txt\n' "$HOME"
fi

rm -f "$BIN_DIR/todo_add" "$BIN_DIR/todo_done" \
      "$BIN_DIR/todo_clear" "$BIN_DIR/todo_edit"
rm -rf "$DATA_DIR"
rm -rf "$WIDGET_DIR"
rm -f "$BSPWMRC.todobak" "$SXHKDRC.todobak"

printf 'removed. conky and rofi were left installed.\n'
