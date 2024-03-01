return {
    "majutsushi/tagbar",  -- shows classes, methods inside file
    config = function()

        -- Disable use_cache when installed via snap.
        -- Tagbar in this setup cannot acces /tmp directory.
        -- Source: https://github.com/preservim/tagbar/issues/714
        vim.g["tagbar_use_cache"] = 0

        -- disable alphabetical sorting
        vim.g["tagbar_sort"] = 0

        -- set keymaps
        local keymap = vim.keymap

        -- universal-ctags are installed via repo clone
        -- Source: https://askubuntu.com/a/836521/1081442
        keymap.set("n", "<F8>", "<cmd>TagbarToggle<cr>", { desc = "Toggle Tagbar" })

    end,
}
