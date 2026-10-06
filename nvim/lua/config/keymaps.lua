-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- CMake projects: build / build-and-run from the outermost CMakeLists.txt
local function cmake(target)
  local files = vim.fs.find("CMakeLists.txt", { upward = true, limit = math.huge, path = vim.fn.expand("%:p:h") })
  local root = files[#files] and vim.fs.dirname(files[#files])
  if not root then
    vim.notify("No CMakeLists.txt found", vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! wall")
  local cmd = "[ -f build/build.ninja ] || cmake -S . -B build -G Ninja -Wno-deprecated; cmake --build build"
  if target then
    cmd = cmd .. " --target " .. target
  end
  Snacks.terminal(cmd, { cwd = root, auto_close = false, win = { position = "bottom", height = 0.3 } })
end
vim.keymap.set("n", "<leader>mb", function() cmake() end, { desc = "CMake build" })
vim.keymap.set("n", "<leader>mr", function() cmake("run") end, { desc = "CMake build & run" })
