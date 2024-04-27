-- set leader key
vim.g.mapleader = " "

local keymap = vim.keymap


-- ---------------------------------------------------------------------------
-- VIM, general
-- ---------------------------------------------------------------------------

-- Currently disabled. Can lead to unexpected behaviour when using term.
-- keymap.set("n", "<Esc>", "<C-\><C-n>")
-- vim.keymap.set("n", "<C-p>", require("nvim-tree.api").tree.toggle)

-- ---------------------------------------------------------------------------
-- Coding
-- ---------------------------------------------------------------------------

-- Quickly insert an empty new line without entering insert mode
keymap.set("n", "<leader>o", "o<Esc>")
keymap.set("n", "<leader>O", "O<Esc>")

-- toggle colorcolumn
keymap.set(
    "n", "<leader>m", "<cmd>exec 'set colorcolumn=' . (&colorcolumn == '' ? '120' : '')<CR>",
    { desc = "Toggle colorcolumn for 120 line characters." }
)

-- Make it possible to paste many times over selected text
keymap.set("v", "<expr> p", "'pgv\"'.v:register.'y`>'")
keymap.set("v", "<expr> P", "'Pgv\"'.v:register.'y`>'")


-- ---------------------------------------------------------------------------
-- Python
-- ---------------------------------------------------------------------------
keymap.set(
    "n", "<F2>", "<cmd>exec winheight(0)/4.'split' | terminal python3 %<CR>",
    { desc = "Executes current file in python3." }
)
