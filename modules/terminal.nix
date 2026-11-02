# modules/terminal.nix
# alacritty wrapped with its config, it opens the multiplexer on start
{
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    config = (pkgs.formats.toml {}).generate "alacritty.toml" {
      terminal.shell = {
        program = "${self'.packages.multiplexer}/bin/tmux";
        args = ["new-session" "-A" "-s" "chimanta"];
      };
      env.TERM = "xterm-256color";
      window = {
        padding = {
          x = 4;
          y = 4;
        };
        dynamic_padding = true;
      };
      scrolling.history = 10000;
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
    };
  in {
    packages.terminal = pkgs.symlinkJoin {
      name = "chimanta-terminal";
      paths = [pkgs.alacritty];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/alacritty --add-flags "--config-file ${config}"
      '';
    };
  };
}
