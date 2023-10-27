local opt = vim.opt

-- enable termguicolors
opt.termguicolors = true

-- cursor line
opt.cursorline = true

-- line number
opt.number = true
opt.relativenumber = true

--  On newline, using c (insert comment leader automatically), r (after hitting
--  enter), o (after hitting o or O)
--  Source: https://superuser.com/questions/271023/can-i-disable-continuation-of-comments-to-the-next-line-in-vim
opt.formatoptions = "cro"

-- clipboard
opt.clipboard = "unnamedplus"

-- allow usage of mouse in editor
opt.mouse = "a"

-- Set tab size to 4 and use spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Do not conceil backticks `, and other symbols in markdown
-- Source: https://vi.stackexchange.com/a/24396
vim.g["vim_json_syntax_conceal"] = 0
vim.g["vim_markdown_conceal"] = 0
vim.g["vim_markdown_conceal_code_blocks"] = 0

