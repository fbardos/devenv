return {
    "nvie/vim-flake8",  -- linting python
    config = function()
        vim.g["flake8_show_in_file"] = 1
        vim.g["flake8_show_in_gutter"] = 1
    end,
    ft = { "python" },
}
