# Chimanta

`chimanta`, named after a mountain in Venezuela, is the workspace for working with `ai`.
Working with `ai` means less time typing and more time reading, so the workspace is built around reading and moving fast with the keyboard, while the mouse still works.

Several instances of `claude code` run side by side inside `tmux`, each window named after the ticket it is working on.

## Tools

| Role        | Tool          | Doc                                          |
| ----------- | ------------- | -------------------------------------------- |
| Terminal    | `alacritty`   | [terminal.md](./modules/terminal.md)         |
| Multiplexer | `tmux`        | [multiplexer.md](./modules/multiplexer.md)   |
| AI          | `claude code` | [ai.md](./modules/ai.md)                     |
| Editor      | `kukenan`     | [editor.md](./modules/editor.md)             |

## How it is built

Chimanta is a standalone `nix` flake, it does not need `home-manager` and it does not write anything to `~/.config`.

It uses [flake-parts](https://flake.parts) with the dendritic pattern: every file in `./modules` is a flake-parts module and [import-tree](https://github.com/vic/import-tree) loads all of them, so `flake.nix` only declares the inputs.

```
flake.nix          inputs + mkFlake (import-tree ./modules)
modules/
  systems.nix      supported systems, pkgs with allowUnfree
  terminal.nix     packages.terminal     alacritty + alacritty.toml
  multiplexer.nix  packages.multiplexer  tmux + tmux.conf
  ai.nix           packages.ai           claude code + settings.json
  editor.nix       packages.editor       kukenan (neovim)
  chimanta.nix     packages.default, devShells.default, formatter
```

Each module sets its own `perSystem` outputs, modules use each other through `self'` (this flake's outputs for the current system) and `inputs'` (the inputs' outputs for the current system), so there is no manual wiring.
To add a tool, add a file to `./modules` and add its package to `modules/chimanta.nix`. Files or directories starting with `_` are ignored by `import-tree`.

The configs are generated into the nix store and the wrapper (`symlinkJoin` + `wrapProgram`) adds the flag that points to them, so the commands keep their usual names: `alacritty`, `tmux`, `claude`.

## Platforms

| System           | Notes                                                      |
| ---------------- | ---------------------------------------------------------- |
| `x86_64-linux`   | Linux and Windows (WSL)                                    |
| `aarch64-linux`  | Linux and Windows on ARM (WSL)                             |
| `aarch64-darwin` | Apple silicon macs                                         |

`x86_64-darwin` (Intel macs) was dropped from nixpkgs unstable in 26.11.

On Windows the recommended setup is the native Windows `alacritty` running `wsl -e tmux new-session -A -s chimanta`, the flake provides everything else inside WSL.

## Usage

```bash
# shell with every tool
nix develop

# build the bundle into ./result
nix build

# build a single tool: terminal, multiplexer, ai, editor
nix build .#multiplexer

# install it into the user profile
nix profile install .

# format the nix files
nix fmt
```

`claude code` is unfree, the flake already sets `allowUnfree = true`.
