# modules/systems.nix
# supported systems and the pkgs every perSystem module receives
{inputs, ...}: {
  # x86_64-darwin (Intel macs) was dropped from nixpkgs unstable in 26.11
  # Windows is supported through WSL (x86_64-linux / aarch64-linux)
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      # claude-code is unfree
      config = {allowUnfree = true;};
    };
  };
}
