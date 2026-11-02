# modules/multiplexer.nix
# tmux wrapped with its config
{
  perSystem = {pkgs, ...}: let
    config = pkgs.writeText "tmux.conf" ''
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:RGB"

      # neovim friendly
      set -sg escape-time 0
      set -g focus-events on

      # keyboard first, mouse also works
      set -g mouse on
      setw -g mode-keys vi

      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      set -g history-limit 10000

      # the window name on top shows the ticket being worked on
      set -g status-position top
      setw -g automatic-rename off
      set -g allow-rename off
    '';
  in {
    packages.multiplexer = pkgs.symlinkJoin {
      name = "chimanta-multiplexer";
      paths = [pkgs.tmux];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/tmux --add-flags "-f ${config}"
      '';
    };
  };
}
