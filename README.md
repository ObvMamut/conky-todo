# conky-todo

A minimal [conky](https://github.com/brndnmtthws/conky) desktop widget that shows
your todo list. Built for BSPWM (it sits on the desktop layer, so the WM never
tiles or focuses it), but it works with any X11 setup.

## Files

| File | Purpose |
| --- | --- |
| `todo.conf` | conky config: position, size, fonts, colours |
| `render.sh` | reads the todo file and prints conky markup |
| `launch.sh` | (re)starts the widget |
| `bin/todo_add` | rofi prompt: add an item |
| `bin/todo_done` | rofi menu: mark an open item done |
| `bin/todo_edit` | open the todo file in `$EDITOR` (default `nvim`) in a terminal |
| `bin/todo_clear` | delete all done items |
| `sxhkdrc.snippet` | example sxhkd key bindings for the helpers |
| `uninstall.sh` | removes the widget (see the warning below) |

## Requirements

- conky (with X11 and Lua support)
- JetBrainsMono Nerd Font (change `font` in `todo.conf` to use another)
- rofi, for `todo_add` and `todo_done`
- a terminal for `todo_edit`: `$TERMINAL`, else alacritty, kitty, wezterm, st or xterm

## Install

```sh
git clone https://github.com/ObvMamut/conky-todo ~/.config/conky/todo
~/.config/conky/todo/launch.sh
```

The install path matters: `todo.conf` calls `$HOME/.config/conky/todo/render.sh`.

Install the helper scripts somewhere on your `PATH` (the snippet below expects
`~/.local/bin`):

```sh
mkdir -p ~/.local/bin
cp ~/.config/conky/todo/bin/todo_* ~/.local/bin/
```

Bind them to keys by adding `sxhkdrc.snippet` to `~/.config/sxhkd/sxhkdrc`
(`super+alt+n` add, `super+alt+d` done, `super+alt+e` edit), then run
`pkill -USR1 sxhkd`. `todo_clear` has no binding; run it from a shell.

To start it with BSPWM, add this to `bspwmrc`:

```sh
$HOME/.config/conky/todo/launch.sh &
```

## Todo file

The widget reads `~/.local/share/todo/todo.txt`, one item per line:

```
[ ] write the README
[x] push to github
a plain line is shown dimmed
```

- `[ ]` is an open item, counted in the header.
- `[x]` is a done item, shown dimmed with a tick.
- Lines longer than 32 characters are truncated (`MAXLEN` in `render.sh`).
- The widget refreshes every 3 seconds.

## Colours

`todo.conf` loads `colors.lua` if it exists. It must return a table with
`bg`, `fg`, `accent`, `green` and `dim` (hex, no `#`). If the file is missing, the
built-in Catppuccin values are used. `colors.lua` is git-ignored because it is
generated per machine.

## Position

`alignment`, `gap_x` and `gap_y` in `todo.conf` place the widget. On a HiDPI
screen the gaps are scaled (on a 192 DPI display, 1 unit moved the widget 2px),
so adjust them by watching the result.

Apply changes without restarting: `pkill -USR1 -f 'conky -c .*todo.conf'`.

## Uninstall

> **Warning:** `uninstall.sh` is written for the author's setup. It kills the
> widget, edits `~/.config/bspwm/bspwmrc` and `~/.config/sxhkd/sxhkdrc` (removing
> the `# >>> todo widget >>>` block), copies your list to `~/todo_backup.txt`,
> and then **deletes `~/.config/conky/todo` and `~/.local/share/todo`**. Read it
> before running it.

## License

[MIT](LICENSE)
