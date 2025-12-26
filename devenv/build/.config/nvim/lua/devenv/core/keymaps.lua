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
local PATTERN = [[\%>88v.*]]

local aug = vim.api.nvim_create_augroup("TooLongLineHL", { clear = true })

local function with_win(win, fn)
  if win == 0 then win = vim.api.nvim_get_current_win() end
  if not vim.api.nvim_win_is_valid(win) then return end
  local cur = vim.api.nvim_get_current_win()
  if cur ~= win then vim.api.nvim_set_current_win(win) end
  local ok, err = pcall(fn)
  if cur ~= win and vim.api.nvim_win_is_valid(cur) then
    vim.api.nvim_set_current_win(cur)
  end
  return ok, err
end

local function ensure_enabled_in_win(win)
  with_win(win, function()
    if vim.w.tooLongDisabled then return end
    if vim.w.tooLongMatchId then return end
    vim.w.tooLongMatchId = vim.fn.matchadd("TooLongLine", PATTERN)
  end)
end

local function disable_in_win(win)
  with_win(win, function()
    local id = vim.w.tooLongMatchId
    if id then
      pcall(vim.fn.matchdelete, id)
      vim.w.tooLongMatchId = nil
    end
  end)
end

-- Auto-enable in any window you enter/create (unless that window disabled it)
vim.api.nvim_create_autocmd({ "WinEnter", "WinNew", "BufWinEnter" }, {
  group = aug,
  callback = function()
    ensure_enabled_in_win(0) -- 0 = current window (reliable)
  end,
})

-- Per-window toggle
function ToggleTooLongHighlight()
  local win = vim.api.nvim_get_current_win()
  with_win(win, function()
    if vim.w.tooLongMatchId then
      vim.w.tooLongDisabled = true
      disable_in_win(win)
    else
      vim.w.tooLongDisabled = false
      ensure_enabled_in_win(win)
    end
  end)
end

vim.keymap.set("n", "<Leader>hl", ToggleTooLongHighlight, { silent = true })

-- Enable immediately for existing windows at startup
for _, win in ipairs(vim.api.nvim_list_wins()) do
  ensure_enabled_in_win(win)
end

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
