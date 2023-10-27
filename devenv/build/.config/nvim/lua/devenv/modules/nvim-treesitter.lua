return {
    "nvim-treesitter/nvim-treesitter",  -- treesitter
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
            ensure_installed = {
                "json",
                "yaml",
                "html",
                "css",
                "markdown",
                "markdown_inline",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "python",
                "sql",
            },
        })

    end,

}
