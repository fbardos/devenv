return {
    -- {
    --     "bluz71/vim-nightfly-guicolors",
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --       -- load the colorscheme here
    --       vim.cmd([[colorscheme nightfly]])
    --     end,
    -- },
    -- {
    --     "navarasu/onedark.nvim",
    --     enabled = true,
    --     priority = 1000 ,
    --     opts = {
    --         code_style = {
    --             comments = 'none',
    --             keywords = 'none',
    --             functions = 'none',
    --             strings = 'none',
    --             variables = 'none'
    --         },
    --         -- Custom Highlights --
    --         colors = {}, -- Override default colors
    --         highlights = {}, -- Override highlight groups
    --     },
    --     config = function()
    --         local onedark = require("onedark")

    --         vim.g.airline_theme = 'onedark'
    --         vim.g.onedark_termcolors = 256
    --         vim.g.onedark_terminal_italics = 0


    --         -- show whitespaces
    --         vim.cmd("autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red")
    --         vim.cmd("au InsertLeave * match ExtraWhitespace /\\s\\+$/")
    --         vim.cmd("set t_Co=256")
    --         vim.cmd("syntax enable")
    --         vim.cmd("syntax on")

    --         onedark.setup({
    --             style = "darker",  -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    --             transparent = false,  -- show/hide background
    --             term_colors = true,  -- change terminal color as per the selected theme style
    --             ending_tildes = true,  -- show end-of-buffer tildes
    --         })

    --         -- For code: syntax highlighting from nvim-treesitter is used
    --         -- syntax on is needed for correct layout of Nerdtree or Tagbar etc.
    --         -- NOT NEEDED ANYMORE
    --         -- vim.syntax = true

    --         -- execute as last command
    --         -- vim.cmd("colorscheme onedark")
    --         vim.cmd([[colorscheme onedark]])
    --     end,
    -- },
    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000 ,
    --     lazy = false,
    --     config = function()

    --         vim.o.background = "dark"
    --         vim.cmd([[colorscheme gruvbox]])

    --     end,
    -- },
    {
        'dasupradyumna/midnight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            colorscheme = 'midnight',
        },
        config = function()
            vim.cmd.colorscheme "midnight"

            -- Add function to easily change HighlightGroups
            local function setHighlightGroup(highlightGroup, opts)
                vim.api.nvim_set_hl(0, highlightGroup, opts)
            end

            -- Change colors for search results (BG green, FG dark-grey)
            setHighlightGroup("Search", { bg = "#edea1a", fg = '#45453a' })

            -- Change colors for git changes
            setHighlightGroup("DiffAdd", { bg = "#0d7222" })
            setHighlightGroup("DiffChange", { bg = "#664e00" })
            setHighlightGroup("DiffDelete", { bg = "#84151a" })
            setHighlightGroup("DiffText", { bg = "#997500" })

        end,
    },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         vim.g.airline_theme = 'catppuccin'
    --         vim.cmd.colorscheme = "catppuccin-mocha"
    --         vim.cmd([[colorscheme catppuccin]])
    --     end,
    -- },
}
