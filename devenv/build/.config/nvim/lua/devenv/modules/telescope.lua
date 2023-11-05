return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
          defaults = {
            path_display = { "truncate " },
            mappings = {
              i = {
                -- ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                -- ["<C-j>"] = actions.move_selection_next, -- move to next result
                -- ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<Esc>"] = actions.close
              },
            },
          },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>f", "<cmd>Telescope find_files theme=ivy<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>g", "<cmd>lua require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_ivy({show_line = true}))<cr>", { desc = "Find LSP symbols in current file" })
        keymap.set("n", "<leader>t", "<cmd>Telescope treesitter theme=ivy<cr>", { desc = "Fuzzy find in treesitter" })
    end,
}
