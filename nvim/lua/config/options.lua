-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local zsh = vim.fn.exepath("zsh")
if zsh ~= "" then
  vim.opt.shell = zsh
end
