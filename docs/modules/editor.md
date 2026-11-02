# Editor

Module: `modules/editor.nix`
Output: `packages.editor`
Tool: `neovim`

[kukenan](https://github.com/juanalbarran/kukenan) is my `neovim` configuration, built as a nix flake with several flavors: `base`, `web`, `java`, `rust`, `csharp`.
It is used to read and review what `claude code` writes.

## How it is added

It is not wrapped, `kukenan` already carries its own config. It comes from the `kukenan` flake input:

```nix
kukenan = {
  url = "github:juanalbarran/kukenan";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

`follows` makes `kukenan` use the same `nixpkgs` as chimanta, so it is downloaded only once.

`modules/editor.nix` exposes the `base` flavor, `inputs'` already selects the current system:

```nix
packages.editor = inputs'.kukenan.packages.neovim.base;
```

The command is `nvim-base`.

## Updating

```bash
nix flake update kukenan
```

## Notes

- `kukenan` builds its lua config while the flake is evaluated, so `aarch64-linux` and `aarch64-darwin` only evaluate on a matching machine or with a remote builder.
- `kukenan` includes `vim-tmux-navigator`, the `tmux` side of it is not configured yet in the [multiplexer](./multiplexer.md).
