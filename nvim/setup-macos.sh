#!/usr/bin/env bash
# Install this Neovim config on macOS. Safe to re-run.
set -euo pipefail

# Physical path, so running it via the ~/.config/nvim symlink doesn't relink it to itself.
config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
stamp="$(date +%Y%m%d-%H%M%S)"

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Re-run this script once the Command Line Tools finish installing." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi

echo "==> Homebrew packages"
brew install neovim git ripgrep fd fzf lazygit tree-sitter-cli node go python cmake ninja
brew install --cask font-jetbrains-mono-nerd-font

# rust.lua expects rustup's proxies in ~/.cargo/bin, which Homebrew's rustup does not use.
if [[ ! -x $HOME/.cargo/bin/rustup ]]; then
  echo "==> rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
"$HOME/.cargo/bin/rustup" component add rust-analyzer rust-src

echo "==> Linking ~/.config/nvim -> $config_dir"
mkdir -p "$HOME/.config"
if [[ "$(readlink "$HOME/.config/nvim" 2>/dev/null)" != "$config_dir" ]]; then
  # Move aside any previous config and its plugin/state dirs so nothing stale is loaded.
  for dir in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
    if [[ -e $dir || -L $dir ]]; then
      mv "$dir" "$dir.bak-$stamp"
      echo "    backed up $dir -> $dir.bak-$stamp"
    fi
  done
  ln -s "$config_dir" "$HOME/.config/nvim"
fi

# Omarchy isn't here to provide the theme, so use the committed snapshot.
if [[ ! -e $config_dir/lua/plugins/theme.lua ]]; then
  ln -sfn ../../themes/omarchy-snapshot.lua "$config_dir/lua/plugins/theme.lua"
fi

mason_packages="asmfmt clangd clang-format codelldb docker-compose-language-service dockerfile-language-server eslint-lsp gofumpt goimports golangci-lint gopls hadolint json-lsp lua-language-server markdownlint-cli2 markdown-toc marksman ols prettier pyright ruff rust-analyzer shfmt sqlfluff stylua taplo typescript-language-server yaml-language-server"

# One session: loading mason also starts LazyVim's ensure_installed, and headless
# MasonInstall skips packages already installing, so wait for all of them before quitting.
echo "==> Plugins (pinned to lazy-lock.json) and Mason tools"
nvim --headless \
  "+Lazy! restore" \
  "+lua require('lazy').load({ plugins = { 'mason.nvim' } })" \
  "+MasonInstall $mason_packages" \
  "+lua vim.wait(1800000, function() for _, p in ipairs(require('mason-registry').get_all_packages()) do if p:is_installing() then return false end end return true end, 500)" \
  +qa

echo
echo "Done. Set your terminal font to \"JetBrainsMono Nerd Font\" and run nvim."
echo "Treesitter parsers compile on first launch; give it a minute."
