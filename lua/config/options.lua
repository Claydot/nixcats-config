-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Share the system clipboard: yank/delete go to it, paste pulls from it.
-- Backed by wl-clipboard (see flake.nix `general` category).
vim.opt.clipboard = "unnamedplus"
