return {
    "github/copilot.vim",
    config = function()

        -- set keymaps
        -- source https://github.com/orgs/community/discussions/8105
        local keymap = vim.keymap
        vim.cmd('imap <silent><script><expr> <C-\\> copilot#Accept("")')
        vim.cmd("let g:copilot_no_tab_map = v:true")
    end,
}
