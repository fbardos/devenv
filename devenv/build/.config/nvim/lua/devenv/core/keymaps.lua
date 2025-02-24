-- set leader key
vim.g.mapleader = " "

local keymap = vim.keymap


-- ---------------------------------------------------------------------------
-- VIM, general
-- ---------------------------------------------------------------------------

-- Currently disabled. Can lead to unexpected behaviour when using term.
-- keymap.set("n", "<Esc>", "<C-\><C-n>")
-- vim.keymap.set("n", "<C-p>", require("nvim-tree.api").tree.toggle)
keymap.set("n", "<leader>hh", "*N", { desc = "Highligh word occurences under cursor." })

-- ---------------------------------------------------------------------------
-- Coding
-- ---------------------------------------------------------------------------

-- Quickly insert an empty new line without entering insert mode
keymap.set("n", "<leader>o", "o<Esc>")
keymap.set("n", "<leader>O", "O<Esc>")

-- toggle colorcolumn
function ToggleColorColumns()
    if vim.wo.colorcolumn == "" then
        vim.wo.colorcolumn = "81,89,121"

        -- Set different colors for different columns
        -- in NVIM, only one ColorColumn color is supported out of the box
        vim.cmd([[highlight ColorColumn guibg=#9E1E1E]])
    else
	-- reset
        vim.wo.colorcolumn = ""
        vim.cmd([[highlight ColorColumn guibg=#212121]])
        vim.opt.cursorline = true -- keep horizontal line
    end
end

vim.api.nvim_set_keymap(
    "n",
    "<leader>m",
    ":lua ToggleColorColumns()<CR>",
    { desc = "Toggle colorcolumn for 80, 88 and 120 line characters.", noremap = true, silent = true }
)

-- Make it possible to paste many times over selected text
keymap.set("v", "<expr> p", "'pgv\"'.v:register.'y`>'")
keymap.set("v", "<expr> P", "'Pgv\"'.v:register.'y`>'")

-- highlight the first 88 characters in a different color
-- than the rest to mark too long lines
vim.api.nvim_set_hl(0, "TooLongLine", { bg = "#664e00" })
local tooLongMatchId = vim.fn.matchadd("TooLongLine", "\\%>88v.*")
function ToggleTooLongHighlight()
  if tooLongMatchId then
    vim.fn.matchdelete(tooLongMatchId)
    tooLongMatchId = nil
  else
    tooLongMatchId = vim.fn.matchadd("TooLongLine", "\\%>88v.*")
  end
end

vim.api.nvim_set_keymap(
  "n", "<Leader>hl", "<cmd>lua ToggleTooLongHighlight()<CR>",
  { noremap = true, silent = true }
)

-- Copilot change accept
vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- ---------------------------------------------------------------------------
-- Python
-- ---------------------------------------------------------------------------
keymap.set(
    "n", "<F2>", "<cmd>exec winheight(0)/4.'split' | terminal python3 %<CR>",
    { desc = "Executes current file in python3." }
)
