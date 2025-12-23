require("devenv.core.keymaps")
require("devenv.core.options")
require("devenv.lazy")

-- Enable syntax highlighting by treesitter
-- With the rewrite of nvim-treesitter (branch: main),
-- this autocmd is needed for filetypes where treesitter highlight
-- should be enabled.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "json" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

