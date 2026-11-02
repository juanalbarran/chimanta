# Multiplexer

Module: `modules/multiplexer.nix`
Output: `packages.multiplexer`
Tool: `tmux`

`tmux` holds the sessions, windows and panes, every `claude code` instance lives in its own window named after the ticket it is working on.

## How it is wrapped

The config is generated with `pkgs.writeText` and passed with `-f`.
`-f` is only read when the server starts, after changing the config kill the server (`tmux kill-server`) or source the file again.

## Config

Same config as [`canaima`](https://github.com/juanalbarran/canaima) (`modules/workspace/multiplexer.nix`), minus what only makes sense there: the `sarisarinama` colours, the `foot`/`ghostty` terminal features and the `default-shell` (here `tmux` starts your `$SHELL`).

| Option                              | Value                       | Why                                                   |
| ----------------------------------- | --------------------------- | ----------------------------------------------------- |
| `default-terminal`                  | `tmux-256color`             | Correct colors and keys inside `tmux`                 |
| `terminal-features`                 | `extkeys:RGB:clipboard`     | For `xterm-256color` (what `alacritty` sets) and `alacritty*` |
| `extended-keys`                     | `on`                        | Combos like `Ctrl+Alt+Shift+[` reach `tmux` intact    |
| `set-clipboard`                     | `on`                        | Copies reach the system clipboard (OSC 52)            |
| `escape-time`                       | `10`                        | Short `Esc` delay for `neovim`; not `0`, `Alt` binds arrive as `Esc` + key |
| `focus-events`                      | `on`                        | `neovim` knows when it gains focus (autoread)         |
| `mouse`                             | `on`                        | Click panes, resize, scroll                           |
| `mode-keys` / `status-keys`         | `vi`                        | Copy mode and the command prompt with vim keys        |
| `base-index` / `pane-base-index`    | `1`                         | Numbers match the keyboard                            |
| `renumber-windows`                  | `on`                        | No gaps when a window is closed                       |
| `history-limit`                     | `50000`                     | Long `claude` outputs                                 |
| `automatic-rename` / `allow-rename` | `off`                       | The window keeps the ticket name                      |

### Status bar

On top, with the window list centred and a blank second line as a gap under it.
`[session]` on the left, nothing on the right. The current window is bold, the others dim.
No colours are set (`bg=default,fg=default`), so it follows the terminal theme.

## Keybinds

On top of the `tmux` defaults (`prefix` is `Ctrl-b`):

| Keys                       | Action                                              |
| -------------------------- | --------------------------------------------------- |
| `Ctrl+h/j/k/l`             | Pane that way, or `neovim` split (`vim-tmux-navigator`, `kukenan` has the `neovim` side) |
| `Ctrl+Alt+h/j/k/l`         | Resize the pane by 3                                |
| `Alt+{` / `Alt+}`          | Previous / next window                              |
| `Ctrl+Alt+{` / `Ctrl+Alt+}`| Move the window left / right                        |
| `prefix` + `x`             | Kill the pane, asks first                           |
| `prefix` + `X`             | Kill the session, asks first                        |
| `v` / `y` in copy mode     | Start the selection / copy it and leave             |

The window binds are bound under several names (`M-{`, `M-S-{`, `M-S-[`) because a terminal can encode the same combo in different ways.

## Naming a window after a ticket

```bash
# new window
tmux new-window -n CTWO-1234 claude

# rename the current one
tmux rename-window CTWO-1234
```

Or `prefix` + `,` to rename from the keyboard, the default `prefix` is `Ctrl-b`.
