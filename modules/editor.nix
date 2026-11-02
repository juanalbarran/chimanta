# modules/editor.nix
# kukenan, my neovim configuration, base flavor
{
  perSystem = {inputs', ...}: {
    packages.editor = inputs'.kukenan.packages.neovim.base;
  };
}
