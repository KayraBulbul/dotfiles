return {
  {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
      -- Desktop sessions can omit rustup and select system Rust without rust-src.
      local cargo_bin = vim.fn.expand("~/.cargo/bin")
      vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
      if vim.fn.executable(cargo_bin .. "/rust-analyzer") == 1 then
        opts.server.cmd = { cargo_bin .. "/rust-analyzer" }
      end
    end,
  },
}
