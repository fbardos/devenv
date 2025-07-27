-- null-ls is not maintained anymore
-- switched to none-ls as drop in replacement
return {
    "nvimtools/none-ls.nvim",  -- LSP integration with linters
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                -- fbardos: Remove spell checking, otherwise getting alot
                -- of meaningless suggestions
                -- null_ls.builtins.completion.spell,
            },
        })
    end,
}
