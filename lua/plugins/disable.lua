return {
    -- Disable mason completely so it doesn't try to download unpatched binaries on NixOS
    { "mason-org/mason.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
}
