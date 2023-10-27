return {
    "folke/todo-comments.nvim",  -- highlight TODO, FIX, ...
    dependencies = {
        "nvim-lua/plenary.nvim",
        'nvim-tree/nvim-web-devicons',  -- Dependency of trouble
        'folke/trouble.nvim',  -- Trouble (e.g. for showing TODOs from todo-comments)
    },
    opts = {
        keywords = {
           FIX = {
             icon = " ", -- icon used for the sign, and in search results
             color = "error", -- can be a hex color, or a named color (see below)
             alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
             -- signs = false, -- configure signs for some keywords individually
           },
           TODO = { icon = " ", color = "info" },
           HACK = { icon = " ", color = "warning" },
           WARN = { icon = " ", color = "warning", alt = { "XXX" } },
           PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
           NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
           TEST = { icon = "⏲ ", color = "test", alt = { }},
         }
    },
}
