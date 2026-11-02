# AI

Module: `modules/ai.nix`
Output: `packages.ai`
Tool: `claude code`

`claude code` is the `ai` agent, several instances run at the same time, one per `tmux` window.

## How it is wrapped

The settings are generated with `pkgs.formats.json` and passed with `--settings`.
They are merged on top of `~/.claude/settings.json`, they do not replace it, so login, model and personal settings keep working.

`claude code` is unfree, `modules/systems.nix` sets `allowUnfree = true`.

## Settings

| Setting              | Value | Why                                         |
| -------------------- | ----- | ------------------------------------------- |
| `attribution.commit` | `""`  | No co-authored line on commits              |
| `attribution.pr`     | `""`  | No attribution line on pull requests        |

Invalid settings are ignored silently by `claude code`, after changing them check that they apply.
