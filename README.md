# dotfiles

Personal dotfiles for Linux shells, terminal tools, and editors.

## Scope

- Primary target: Linux
- macOS bits exist but are legacy/unmaintained
- Several settings are host-specific (based on `hostname`)

## Quick Start

1. Clone to `~/dotfiles`.
2. Link top-level dotfiles:

```bash
cd ~/dotfiles
./makesymlinks.sh
```

3. Optional X11 resources:

```bash
./makesymlinks.sh xserver
```

4. Link app configs in `~/.config`:

```bash
mkdir -p ~/.config
ln -snf ~/dotfiles/config/nvim ~/.config/nvim
ln -snf ~/dotfiles/config/fastfetch ~/.config/fastfetch
```

5. Reload shell:

```bash
source ~/.bash_profile
```

## What Is Included

- `bash_profile`: login shell environment and host-specific setup
- `bashrc`: interactive shell behavior, prompt, history sync
- `bash_aliases`: aliases/functions per platform/host
- `inputrc`: readline completion and tab behavior
- `tmux.conf`: keybindings, statusline, clipboard behavior
- `Xresources`: xterm look/behavior (used with `xserver` option)
- `config/nvim/init.lua`: Neovim base settings
- `config/fastfetch/config.jsonc`: fastfetch module layout
- `emacs`: Emacs init file

## Utilities

- `makesymlinks.sh`: backs up existing dotfiles to `~/dotfiles_old` (timestamped) and recreates symlinks
- `tmuxreconnect`: source this to resync tmux environment variables after reattach
- `freemem.sh`: prints current RAM usage percentage

## Notes

- The script links standard dotfiles and `~/bin/freemem.sh`.
- If a source file is missing, `makesymlinks.sh` skips it and continues.
- `gitconfig` currently uses `credential.helper=store`.
