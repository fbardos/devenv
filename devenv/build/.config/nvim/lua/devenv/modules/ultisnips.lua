return {
    "SirVer/ultisnips",  -- Engine for the code snippets
    dependencies = {
        "honza/vim-snippets",  -- Snippets itself
        "quangnguyen30192/cmp-nvim-ultisnips",  -- Ultisnip integration into Drop-down from nvim-cmp
    },
    config = function()
        vim.g["UltiSnipsExpandTrigger"] = "<S-Tab>"
    end,
}
