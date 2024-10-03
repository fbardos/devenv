return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

        -- Modify theme
        local custom_theme = require'lualine.themes.everforest'

        -- similar to https://github.com/sainnhe/everforest
        -- , mixed with high contrast serene colors
        local colors = {
          --bg           = '#272E33',
          bg           = '#3d484d',
          bg_inactive  = '#232a2e',
          text         = '#9da9a0',
          con_red      = '#e01c00',
          con_green    = '#1ce000',
          con_yellow   = '#e0e002',
          con_magenta  = '#e000e0',
          con_cyan     = '#32e0e0',
        }

        -- NORMAL
        custom_theme.normal.a = { bg = colors.bg, fg = colors.con_green, gui = 'bold' }
        custom_theme.normal.b = { bg = colors.bg, fg = colors.text }
        custom_theme.normal.c = { bg = colors.bg, fg = colors.text }

        -- INSERT
        custom_theme.insert.a = { bg = colors.bg, fg = colors.con_magenta, gui = 'bold' }
        custom_theme.insert.b = { bg = colors.bg, fg = colors.text }
        custom_theme.insert.c = { bg = colors.bg, fg = colors.text }

        -- VISUAL
        custom_theme.visual.a = { bg = colors.bg, fg = colors.con_cyan, gui = 'bold' }
        custom_theme.visual.b = { bg = colors.bg, fg = colors.text }
        custom_theme.visual.c = { bg = colors.bg, fg = colors.text }

        -- REPLACE
        custom_theme.replace.a = { bg = colors.bg, fg = colors.con_yellow, gui = 'bold' }
        custom_theme.replace.b = { bg = colors.bg, fg = colors.text }
        custom_theme.replace.c = { bg = colors.bg, fg = colors.text }

        -- COMMAND
        custom_theme.command.a = { bg = colors.bg, fg = colors.con_red, gui = 'bold' }
        custom_theme.command.b = { bg = colors.bg, fg = colors.text }
        custom_theme.command.c = { bg = colors.bg, fg = colors.text }

        -- INACTIVE
        custom_theme.inactive.a = { bg = colors.bg_inactive, fg = colors.text }
        custom_theme.inactive.b = { bg = colors.bg_inactive, fg = colors.text }
        custom_theme.inactive.c = { bg = colors.bg_inactive, fg = colors.text }

        require('lualine').setup({
            options = { theme = custom_theme },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', {
                    'diagnostics',
                    diagnostics_color = {
                        error = { fg = colors.con_red },
                        warn = { fg = colors.con_yellow},
                        info = { fg = colors.text},
                        hint = { fg = colors.text},
                    },
                }},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress', 'location'},
                lualine_z = {},
            }
        })
    end,
}

