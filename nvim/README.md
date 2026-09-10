# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## LC-3 assembly

LC-3 instruction snippets include operand placeholders and descriptions, including
Minecraft course commands such as `CHAT`, `GETP`, and `SETB`. Completion uses the
configured snippet engine; no language server is required.

Files ending in `.lc3`, and `.asm` files anywhere under a directory named `uni`,
use LC-3 highlighting and formatting. For other assembly files, run `:set ft=lc3`.

- In insert mode, use `Ctrl+Space` to open completion and its documentation.
- Use `Ctrl+Y` to accept an instruction, then `Tab`/`Shift+Tab` between operands.
- Use `<leader>cf` to format. The spacing formatter requires `python3` and preserves
  operands, strings, comments, and Minecraft instructions. Existing autoformat
  settings still apply.

On another machine, pull this repository and copy or symlink its `nvim` directory
into `~/.config/nvim`, preserving any machine-specific configuration you need.
Restart Neovim after syncing.
