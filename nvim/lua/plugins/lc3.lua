return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.filetype.add({
        extension = { lc3 = "lc3" },
        pattern = { [".*/PS2/.*%.asm"] = "lc3" },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lc3",
        callback = function()
          vim.bo.commentstring = "; %s"
          vim.bo.expandtab = true
          vim.bo.shiftwidth = 4
          vim.bo.tabstop = 4
        end,
      })
    end,
    opts = {
      formatters_by_ft = { lc3 = { "lc3_spacing" } },
      formatters = {
        lc3_spacing = {
          command = "python3",
          args = { vim.fn.stdpath("config") .. "/tools/lc3-format.py" },
          stdin = true,
        },
      },
    },
  },
}
