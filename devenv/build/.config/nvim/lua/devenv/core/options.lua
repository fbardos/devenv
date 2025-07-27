local opt = vim.opt

-- set shell
opt.shell = "/bin/bash"

-- enable termguicolors
opt.termguicolors = true

-- cursor line
opt.cursorline = true

-- line number
-- fbardos (2024-09-15): disabled number to keep it clean
opt.number = false
opt.relativenumber = false

-- disabled signcolumn by default for a cleaner look
opt.signcolumn = "no"

--  On newline, using c (insert comment leader automatically), r (after hitting
--  enter), o (after hitting o or O)
--  Source: https://superuser.com/questions/271023/can-i-disable-continuation-of-comments-to-the-next-line-in-vim
opt.formatoptions = "cro"

-- clipboard
opt.clipboard = "unnamedplus"

-- disable mouse per default
opt.mouse = ""

-- Set tab size to 4 and use spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Do not conceil backticks `, and other symbols in markdown
-- Source: https://vi.stackexchange.com/a/24396
vim.g["vim_json_syntax_conceal"] = 0
vim.g["vim_markdown_conceal"] = 0
vim.g["vim_markdown_conceal_code_blocks"] = 0

-- highlight extra whitespace
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = "#84151a" })
vim.cmd.match({ 'ExtraWhitespace', '/\\s\\+$/' })

-- set python provider to system-wide python with the installed pynvim package
vim.g.python3_host_prog = '/opt/venv/bin/python'

-- set diagnostics
vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
})
