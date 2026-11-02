# modules/multiplexer.nix
# tmux wrapped with its config, same keybinds and status bar as canaima
{
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    # One combo reaches tmux under different names depending on how the
    # terminal encodes it, so every action is bound to all of them.
    bindAll = action: keys: map (key: "bind -n ${key} ${action}") keys;

    config = pkgs.writeText "tmux.conf" (lib.concatLines (
      [
        ''set -g default-terminal "tmux-256color"''
        # alacritty runs with TERM=xterm-256color (see terminal.nix)
        "set -as terminal-features 'xterm-256color:extkeys:RGB:clipboard'"
        "set -as terminal-features 'alacritty*:extkeys:RGB:clipboard'"
        "set -s extended-keys on"
        "set -s set-clipboard on"

        # neovim friendly. escape-time is not 0: Alt binds arrive as Esc + key
        "set -s escape-time 10"
        "set -g focus-events on"

        # keyboard first, mouse also works
        "set -g mouse on"
        "set -g mode-keys vi"
        "set -g status-keys vi"

        "set -g base-index 1"
        "setw -g pane-base-index 1"
        "set -g renumber-windows on"
        "set -g history-limit 50000"

        # the window name shows the ticket being worked on
        "setw -g automatic-rename off"
        "set -g allow-rename off"

        # ctrl+h/j/k/l moves between panes, or nvim splits (kukenan has the nvim side)
        "run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator.rtp}"

        # Status bar: on top, window list centred, a blank line under it as a gap
        "set -g status 2"
        ''set -g status-format[1] ""''
        "set -g status-position top"
        "set -g status-justify absolute-centre"
        "set -g status-style bg=default,fg=default"
        "set -g status-left '[#S] '"
        "set -g status-left-length 50"
        "set -g status-right ''"
        "set -g window-status-format '#W'"
        "set -g window-status-current-format '#W'"
        "set -g window-status-separator '   '"
        "set -g window-status-style dim"
        "set -g window-status-current-style bold"

        "bind x confirm-before -p 'kill pane #P? (y/n)' kill-pane"
        "bind X confirm-before -p 'kill session #S? (y/n)' kill-session"
        "bind -T copy-mode-vi v send -X begin-selection"
        "bind -T copy-mode-vi y send -X copy-selection-and-cancel"

        # resize the pane, also from nvim
        "bind -n C-M-h resize-pane -L 3"
        "bind -n C-M-j resize-pane -D 3"
        "bind -n C-M-k resize-pane -U 3"
        "bind -n C-M-l resize-pane -R 3"
      ]
      ++ bindAll "previous-window" ["M-\\{" "M-S-\\{" "M-S-["]
      ++ bindAll "next-window" ["M-\\}" "M-S-\\}" "M-S-]"]
      ++ bindAll "swap-window -d -t -1" ["C-M-\\{" "C-M-S-\\{" "C-M-S-["]
      ++ bindAll "swap-window -d -t +1" ["C-M-\\}" "C-M-S-\\}" "C-M-S-]"]
    ));
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
