return {
    "othree/eregex.vim",  -- add PERL style regexp support

    -- disable by default but make available with <leader>/
    init = function()
        vim.g.eregex_default_enable = 0
    end,
    config = function()
        local keymap = vim.keymap
        keymap.set("n", "<leader>/", ":call eregex#toggle()<CR>")
    end
}
