return {
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.python" },

  -- All of these binaries come from the nix flake (flake.nix), not Mason.
  -- `mason = false` tells LazyVim not to try installing/managing them itself,
  -- since Mason's downloaded binaries don't work on NixOS.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = { mason = false },
        clangd = { mason = false },
        basedpyright = { mason = false },
        ruff = { mason = false },
      },
    },
  },
}
