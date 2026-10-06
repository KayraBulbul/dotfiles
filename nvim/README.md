# Neovim

LazyVim config shared between Omarchy (Linux) and macOS. On both machines
`~/.config/nvim` is a symlink to `~/dotfiles/nvim`.

## macOS setup

```sh
git clone https://github.com/KayraBulbul/dotfiles.git ~/dotfiles
~/dotfiles/nvim/setup-macos.sh
```

The script installs the CLI tools via Homebrew, rustup, the plugins pinned in
`lazy-lock.json`, and the same Mason tools as the Linux machine. Any existing
nvim config/data is moved to `*.bak-<timestamp>`. Use a terminal with a Nerd
Font (JetBrainsMono Nerd Font is installed).

## Theme

`lua/plugins/theme.lua` is per-machine and not tracked:

- **Linux:** Omarchy's symlink to `~/.local/state/omarchy/current/theme/neovim.lua`,
  so `omarchy-theme-set` hot-reloads nvim.
- **macOS:** a symlink to `themes/omarchy-snapshot.lua`.

To carry a new Omarchy theme over to the Mac:

```sh
cp ~/.local/state/omarchy/current/theme/neovim.lua ~/dotfiles/nvim/themes/omarchy-snapshot.lua
```

## Syncing

Commit and push from either machine, `git pull` on the other, then run
`:Lazy restore` so plugins match `lazy-lock.json`.
