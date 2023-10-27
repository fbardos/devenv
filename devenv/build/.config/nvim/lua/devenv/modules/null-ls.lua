return {
    "jose-elias-alvarez/null-ls.nvim",  -- LSP integration with linters
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.eslint,
                -- fbardos: Remove spell checking, otherwise getting alot
                -- of meaningless suggestions
                -- null_ls.builtins.completion.spell,
            },
        })
    end,
}
