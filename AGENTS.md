# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed with [chezmoi](https://chezmoi.io). This directory (`~/.local/share/chezmoi`) is chezmoi's *source* directory — files here use chezmoi's naming conventions and are rendered/installed into `$HOME` on the target machine, they are not consumed directly from this path.

**Use the `chezmoi` skill (`.claude/skills/chezmoi-skill/SKILL.md`) for any work in this repo.** It covers chezmoi's source-file naming conventions (`dot_`, `private_`, `executable_`, `.tmpl`), machine-specific templating patterns, the required `chezmoi apply --refresh-externals --force` flags, `.chezmoiremove`/`.chezmoiexternal.toml`, and troubleshooting — invoke it rather than re-deriving this from scratch.

## Commands

Preview and apply changes (run from anywhere; chezmoi finds the source dir automatically):

```bash
chezmoi diff                                  # preview pending changes before applying
chezmoi apply --refresh-externals --force     # apply — always use both flags (force avoids interactive prompts Claude can't answer)
chezmoi cat <file>                            # preview a rendered template's output
chezmoi execute-template '{{ .chezmoi.os }}'  # test a template snippet in isolation
chezmoi re-add <file>                         # pull an edited target file back into the source dir
chezmoi status                                # what's pending
```

Syncing to git (per README.md):

```bash
chezmoi cd            # cd into the source dir (this repo)
git add --all && git commit && git push
chezmoi update        # pull + apply on another machine
```

There is no build, lint, or test suite — this is a config repo. "Testing" a change means `chezmoi diff`/`chezmoi cat` to check rendering, then `chezmoi apply --refresh-externals --force` and exercising the shell/tool it affects.

## Architecture

- **`run_onchange_before_NN_*.sh`** — idempotent setup scripts chezmoi re-runs whenever their content hash changes, in numeric order (`0` installs apt packages, `1` sets zsh as default shell and installs antidote, `20`+ install individual tools: fzf, diff-so-fancy, vim-plug, tmux plugin manager, lazygit, fonts, nbdime). New machine-setup steps should follow this pattern: a numbered `run_onchange_before_*.sh` with `set -euo pipefail` and an existence check so re-runs are no-ops.
- **`.chezmoi.toml.tmpl`** — chezmoi's own config template. Interactively prompts once for `github_email`/`machineClass` on a real terminal; when non-interactive (`stdinIsATTY` false), `CODESPACES` is set, or `.chezmoi.username` is `vscode` — auto-detected as `ephemeral`, overridable via `CHEZMOI_EPHEMERAL` — it skips prompting and instead reads `CHEZMOI_GITHUB_EMAIL` (may be left empty) and `CHEZMOI_MACHINE_CLASS` (defaults to `public`). `ephemeral` is written to `[data]` alongside `machineClass`/`github_email` and gates lifecycle-only setup (fonts — see `run_onchange_before_25_fonts.sh.tmpl`). `chezmoi apply` never auto-commits/pushes to this repo on any machine; sync manually per the Commands section below.
- **Shell startup chain**: `dot_zshrc` sources `bin/term-background` (must run before the p10k instant-prompt block, since it reads the tty for OSC 11 background detection) → p10k instant prompt → `~/.environment`(`dot_environment`) + optional `~/.environment.local` → `~/.aliases` (`dot_aliases`) + optional `~/.aliases.local` → antidote plugin load (plugin list in `dot_zsh_plugins.txt`) → `~/.p10k.zsh`. The `.local` files are gitignored, host-specific overrides — never add machine-specific values directly to the tracked files.
- **`dot_gitconfig.tmpl`** — templated on `.github_email`, whose `[user] email` line is omitted entirely when `.github_email` is empty (e.g. an ephemeral machine with no `CHEZMOI_GITHUB_EMAIL` set); wires up diff-so-fancy as the pager and nbdime for Jupyter notebook diffing. `~/.gitconfig.local` (untracked) is included for machine-specific overrides.
- **`private_dot_config/`** → installs to `~/.config/` with restrictive permissions (nvim, matplotlib styles, fontconfig).
- **`bin/`** → installs to `~/bin/`; `executable_term-background` detects terminal light/dark background via OSC 11 for theme-matching in nvim etc.
- **`.chezmoiignore`** lists source-repo-only paths (`README.md`, `.codex`, `.agents`, `CLAUDE.md`, `CLAUDE.local.md`, `key.txt.age`) that chezmoi should never install to `$HOME`, plus a `machineClass`-gated conditional excluding `.ssh/config.d/home`, `.ssh/config.d/web`, and `.claude/settings.json` on any machine that isn't `machineClass = "private"` — `~/.claude/settings.json` has no user-level `.local.json` merge mechanism, so machines with differing Claude Code config (e.g. `enabledPlugins`) manage that file by hand instead of via chezmoi.
- **Age encryption**: `key.txt.age` (repo root) is an age private key encrypted with a passphrase.`run_onchange_before_02_decrypt-age-key.sh.tmpl` decrypts it into `~/.config/chezmoi/key.txt`.
