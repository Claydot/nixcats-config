-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "c", "cpp", "python" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

-- Nix has no real DAP debugger (it's a lazy, pure language with no call
-- stack to step through). The closest thing is the experimental REPL
-- debugger, which drops into an interactive repl on eval failure.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function(ev)
    vim.keymap.set("n", "<leader>cr", function()
      vim.cmd("split | terminal nix repl --debugger " .. vim.fn.getcwd())
    end, { buffer = ev.buf, desc = "Nix REPL (debugger)" })
  end,
})
