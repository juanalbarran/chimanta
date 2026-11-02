# modules/chimanta.nix
# the workspace: every tool bundled together
{
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    tools = with self'.packages; [
      terminal
      multiplexer
      ai
      editor
    ];
  in {
    packages.default = pkgs.buildEnv {
      name = "chimanta";
      paths = tools;
    };
    devShells.default = pkgs.mkShell {
      packages = tools;
    };
    formatter = pkgs.alejandra;
  };
}
