return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- Modify theme
        local custom_theme = require'lualine.themes.everforest'

        -- similar to https://github.com/sainnhe/everforest
        -- , mixed with high contrast serene colors
        local colors = {
          bg           = '#518071',
          bg_inactive  = '#474747',
          text         = '#9da9a0',
          mid_black    = '#212121',
          con_red      = '#e01c00',
          con_green    = '#1ce000',
          con_yellow   = '#e0e002',
          con_magenta  = '#e000e0',
          con_cyan     = '#32e0e0',
        }

        -- NORMAL
        custom_theme.normal.a = { bg = colors.bg, fg = colors.mid_black, gui = 'bold' }
        custom_theme.normal.b = { bg = colors.bg, fg = colors.mid_black }
        custom_theme.normal.c = { bg = colors.bg, fg = colors.mid_black }

        -- INSERT
        custom_theme.insert.a = { bg = colors.bg, fg = colors.con_magenta, gui = 'bold' }
        custom_theme.insert.b = { bg = colors.bg, fg = colors.mid_black }
        custom_theme.insert.c = { bg = colors.bg, fg = colors.mid_black }

        -- VISUAL
        custom_theme.visual.a = { bg = colors.bg, fg = colors.con_cyan, gui = 'bold' }
        custom_theme.visual.b = { bg = colors.bg, fg = colors.mid_black }
        custom_theme.visual.c = { bg = colors.bg, fg = colors.mid_black }

        -- REPLACE
        custom_theme.replace.a = { bg = colors.bg, fg = colors.con_yellow, gui = 'bold' }
        custom_theme.replace.b = { bg = colors.bg, fg = colors.mid_black }
        custom_theme.replace.c = { bg = colors.bg, fg = colors.mid_black }

        -- COMMAND
        custom_theme.command.a = { bg = colors.bg, fg = colors.con_red, gui = 'bold' }
        custom_theme.command.b = { bg = colors.bg, fg = colors.mid_black }
        custom_theme.command.c = { bg = colors.bg, fg = colors.mid_black }

        -- INACTIVE
        custom_theme.inactive.a = { bg = colors.bg_inactive, fg = colors.mid_black }
        custom_theme.inactive.b = { bg = colors.bg_inactive, fg = colors.mid_black }
        custom_theme.inactive.c = { bg = colors.bg_inactive, fg = colors.mid_black }

        require('lualine').setup({
            options = {
                theme = custom_theme,
                icons_enabled = false,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff'},
                lualine_c = {'%f', '%r'},
                lualine_x = {
                    {
                        'diagnostics',
                        diagnostics_color = {
                            error = { fg = colors.con_red},
                            warn = { fg = colors.con_yellow},
                            info = { fg = colors.mid_black},
                            hint = { fg = colors.mid_black},
                        },
                    },
                    'encoding', 'fileformat', 'filetype',
                },
                lualine_y = {'progress', 'location'},
                lualine_z = {},
            }
        })
    end,
}

