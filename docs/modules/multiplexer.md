# Multiplexer

Module: `modules/multiplexer.nix`
Output: `packages.multiplexer`
Tool: `tmux`

`tmux` holds the sessions, windows and panes, every `claude code` instance lives in its own window named after the ticket it is working on.

## How it is wrapped

The config is generated with `pkgs.writeText` and passed with `-f`.
`-f` is only read when the server starts, after changing the config kill the server (`tmux kill-server`) or source the file again.

## Config

| Option                                 | Value                    | Why                                                 |
| -------------------------------------- | ------------------------ | --------------------------------------------------- |
| `default-terminal`                     | `tmux-256color`          | Correct colors and keys inside `tmux`               |
| `terminal-overrides`                   | `xterm-256color:RGB`     | True color from `alacritty`                         |
| `escape-time`                          | `0`                      | No delay on `Esc` in `neovim`                       |
| `focus-events`                         | `on`                     | `neovim` knows when it gains focus (autoread)       |
| `mouse`                                | `on`                     | Click panes, resize, scroll                         |
| `mode-keys`                            | `vi`                     | Copy mode with vim keys                             |
| `base-index` / `pane-base-index`       | `1`                      | Numbers match the keyboard                          |
| `renumber-windows`                     | `on`                     | No gaps when a window is closed                     |
| `history-limit`                        | `10000`                  | Long `claude` outputs                               |
| `status-position`                      | `top`                    | The ticket names are on top                         |
| `automatic-rename` / `allow-rename`    | `off`                    | The window keeps the ticket name                    |

## Naming a window after a ticket

```bash
# new window
tmux new-window -n CTWO-1234 claude

# rename the current one
tmux rename-window CTWO-1234
```

Or `prefix` + `,` to rename from the keyboard, the default `prefix` is `Ctrl-b`.
