# modules/ai.nix
# claude code wrapped with its settings, they are merged on top of ~/.claude/settings.json
{
  perSystem = {pkgs, ...}: let
    settings = (pkgs.formats.json {}).generate "claude-settings.json" {
      # no co-authored line on commits or pull requests
      attribution = {
        commit = "";
        pr = "";
      };
    };
  in {
    packages.ai = pkgs.symlinkJoin {
      name = "chimanta-ai";
      paths = [pkgs.claude-code];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude --add-flags "--settings ${settings}"
      '';
    };
  };
}
