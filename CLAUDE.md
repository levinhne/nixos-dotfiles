# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Rebuild Commands

```bash
# Rebuild and switch current host (fish alias)
nrs

# Rebuild specific host
nrs-host nixos-levinhne
nrs-host nixos-vinhlq21

# Rebuild manually
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne

# Check flake for syntax errors (before applying)
nix flake check

# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d   # or: clean
```

## Architecture Overview

### Entry Point & Host Construction

`flake.nix` → `lib/mkHost.nix` is the composition pipeline. `mkHost` takes `{ hostname, username }` and wires together:
1. **Disko** (disk partitioning) from `hosts/<hostname>/disko.nix`
2. **NixOS modules** from `hosts/<hostname>/default.nix`
3. **Home-manager** pointed at `home/default.nix`, which imports `home/profiles/desktop.nix`

Two special package sets flow through `specialArgs`/`extraSpecialArgs`:
- `pkgs` — stable nixpkgs (nixos-25.11)
- `pkgs-unstable` — nixos-unstable, for packages that need newer versions

### Host Configuration Layer

```
hosts/
  common/
    base.nix      # system modules: boot, nix, networking, user, secrets, ssh, docker
    desktop.nix   # desktop modules: audio, bluetooth, display-manager, fonts, niri, sway, fcitx5
  nixos-levinhne/ # personal laptop
  nixos-vinhlq21/ # work laptop
```

Each host `default.nix` imports `common/base.nix` + `common/desktop.nix` + host-specific overrides.

### Home-manager Layer

```
home/
  profiles/desktop.nix   # master import list for all home modules; sets colorScheme = dracula
  core/                  # base packages, GTK, xdg
  shell/                 # fish, bash, zsh, neovim, helix, tmux
  terminal/              # kitty, foot
  wm/                    # sway, niri, waybar, mako, kanshi, wpaperd
  dev/                   # git, direnv, claude-code, crush, gitnexus, opencode, webdiff
```

`home/shell/common.nix` is the single source of truth for shell aliases and rebuild functions — fish, bash, and zsh all import from it.

### Theme System

`home/profiles/desktop.nix` sets `colorScheme = nix-colors.colorSchemes.dracula`. This `colorScheme` attribute is passed through home-manager's module system and consumed by WM/terminal configs via `{ colorScheme, ... }` args. All colors flow from this single declaration.

Fonts are defined as a local `fonts` attrset in `desktop.nix` and passed via `_module.args`.

### Secret Management (Agenix)

Secrets are encrypted `.age` files in `secrets/`. Declared in `modules/system/secrets.nix` and decrypted at boot to `/run/agenix/<name>`.

Shell init (`home/shell/common.nix`) reads from `/run/agenix/` and exports as env vars (e.g. `ANTHROPIC_AUTH_TOKEN`, `FPT_API_KEY`).

To add a new secret:
1. Add public keys to `secrets/secrets.nix`, then `agenix -e secrets/my-secret.age`
2. Declare in `modules/system/secrets.nix`
3. Export in `home/shell/common.nix` → `secretFiles` list if it needs to be an env var

### Raw Config Files

`config/` contains raw config files (nvim, kitty, sway, waybar, etc.) managed via `home.file` or `xdg.configFile` in the corresponding home-manager modules. Neovim uses lazy.nvim.

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **nixos-dotfiles** (430 symbols, 447 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## When Debugging

1. `gitnexus_query({query: "<error or symptom>"})` — find execution flows related to the issue
2. `gitnexus_context({name: "<suspect function>"})` — see all callers, callees, and process participation
3. `READ gitnexus://repo/nixos-dotfiles/process/{processName}` — trace the full execution flow step by step
4. For regressions: `gitnexus_detect_changes({scope: "compare", base_ref: "main"})` — see what your branch changed

## When Refactoring

- **Renaming**: MUST use `gitnexus_rename({symbol_name: "old", new_name: "new", dry_run: true})` first. Review the preview — graph edits are safe, text_search edits need manual review. Then run with `dry_run: false`.
- **Extracting/Splitting**: MUST run `gitnexus_context({name: "target"})` to see all incoming/outgoing refs, then `gitnexus_impact({target: "target", direction: "upstream"})` to find all external callers before moving code.
- After any refactor: run `gitnexus_detect_changes({scope: "all"})` to verify only expected files changed.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Tools Quick Reference

| Tool | When to use | Command |
|------|-------------|---------|
| `query` | Find code by concept | `gitnexus_query({query: "auth validation"})` |
| `context` | 360-degree view of one symbol | `gitnexus_context({name: "validateUser"})` |
| `impact` | Blast radius before editing | `gitnexus_impact({target: "X", direction: "upstream"})` |
| `detect_changes` | Pre-commit scope check | `gitnexus_detect_changes({scope: "staged"})` |
| `rename` | Safe multi-file rename | `gitnexus_rename({symbol_name: "old", new_name: "new", dry_run: true})` |
| `cypher` | Custom graph queries | `gitnexus_cypher({query: "MATCH ..."})` |

## Impact Risk Levels

| Depth | Meaning | Action |
|-------|---------|--------|
| d=1 | WILL BREAK — direct callers/importers | MUST update these |
| d=2 | LIKELY AFFECTED — indirect deps | Should test |
| d=3 | MAY NEED TESTING — transitive | Test if critical path |

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/nixos-dotfiles/context` | Codebase overview, check index freshness |
| `gitnexus://repo/nixos-dotfiles/clusters` | All functional areas |
| `gitnexus://repo/nixos-dotfiles/processes` | All execution flows |
| `gitnexus://repo/nixos-dotfiles/process/{name}` | Step-by-step execution trace |

## Self-Check Before Finishing

Before completing any code modification task, verify:
1. `gitnexus_impact` was run for all modified symbols
2. No HIGH/CRITICAL risk warnings were ignored
3. `gitnexus_detect_changes()` confirms changes match expected scope
4. All d=1 (WILL BREAK) dependents were updated

## Keeping the Index Fresh

After committing code changes, the GitNexus index becomes stale. Re-run analyze to update it:

```bash
npx gitnexus analyze
```

If the index previously included embeddings, preserve them by adding `--embeddings`:

```bash
npx gitnexus analyze --embeddings
```

To check whether embeddings exist, inspect `.gitnexus/meta.json` — the `stats.embeddings` field shows the count (0 means no embeddings). **Running analyze without `--embeddings` will delete any previously generated embeddings.**

> Claude Code users: A PostToolUse hook handles this automatically after `git commit` and `git merge`.

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
