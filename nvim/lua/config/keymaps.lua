-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local terminal = { buf = nil, win = nil }

local function toggle_bottom_terminal()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_close(terminal.win, false)
    terminal.win = nil
    return
  end

  if not terminal.buf or not vim.api.nvim_buf_is_valid(terminal.buf) then
    terminal.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[terminal.buf].bufhidden = "hide"
  end

  vim.cmd("botright 15split")
  terminal.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(terminal.win, terminal.buf)
  vim.wo[terminal.win].number = false
  vim.wo[terminal.win].relativenumber = false
  vim.wo[terminal.win].signcolumn = "no"

  if vim.bo[terminal.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell)
  end

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>t", toggle_bottom_terminal, { desc = "Open Terminal" })

vim.keymap.set("t", "<C-q>", function()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_close(terminal.win, false)
    terminal.win = nil
  end
end, { desc = "Close Terminal" })

vim.keymap.set("t", "<Esc>", function()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_close(terminal.win, false)
    terminal.win = nil
  end
end, { desc = "Close Terminal" })

vim.keymap.set("n", "<leader>c", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlights" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half Page Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half Page Up" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste Without Yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete Without Yanking" })

vim.keymap.set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end, { desc = "Copy Full File Path" })

vim.keymap.set("n", "<leader>ce", function()
  if vim.bo.filetype ~= "go" then
    vim.notify("<leader>ce is only available in Go files", vim.log.levels.WARN)
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""

  vim.api.nvim_buf_set_lines(0, row, row, false, {
    indent .. "if err != nil {",
    indent .. "\treturn err",
    indent .. "}",
  })
end, { desc = "Insert Go Error Check" })
