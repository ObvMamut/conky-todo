#!/bin/sh
CONF="$HOME/.config/conky/todo/todo.conf"
pkill -f 'conky.*todo/todo.conf' >/dev/null 2>&1
sleep 1
conky -c "$CONF" >/dev/null 2>&1 &
