# Terminal

Module: `modules/terminal.nix`
Output: `packages.terminal`
Tool: `alacritty`

`alacritty` is a fast, GPU accelerated terminal that runs on Linux, macOS and Windows.
It has no tabs or splits, that is the job of the [multiplexer](./multiplexer.md).

## How it is wrapped

The config is generated with `pkgs.formats.toml` and passed with `--config-file`.
The shell is `self'.packages.multiplexer`, so `alacritty` always starts the chimanta `tmux`, not the one on the system.

## Config

| Option                         | Value                                    | Why                                                |
| ------------------------------ | ---------------------------------------- | -------------------------------------------------- |
| `terminal.shell`               | `tmux new-session -A -s chimanta`        | Open straight into the `chimanta` session, or attach to it if it exists |
| `env.TERM`                     | `xterm-256color`                         | Known by every system, `tmux` adds true color on top |
| `window.padding`               | `4 x 4`                                  | Some air around the text                           |
| `window.dynamic_padding`       | `true`                                   | Spread the leftover pixels evenly                  |
| `scrolling.history`            | `10000`                                  | Long `claude` outputs                              |
| `selection.save_to_clipboard`  | `true`                                   | Copy on select                                     |
| `mouse.hide_when_typing`       | `true`                                   | Keep the text clear                                |

## Windows

Inside WSL `alacritty` only runs through WSLg, use the native Windows `alacritty` instead and set its shell to:

```toml
[terminal.shell]
program = "wsl"
args = ["-e", "tmux", "new-session", "-A", "-s", "chimanta"]
```
