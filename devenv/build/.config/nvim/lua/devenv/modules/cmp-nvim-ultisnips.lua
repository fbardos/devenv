return {
    "quangnguyen30192/cmp-nvim-ultisnips",  -- Ultisnip integration into Drop-down from nvim-cmp
    opts = {
        filetype_source = "treesitter",
        show_snippets = "all",
        documentation = function(snippet)
          return snippet.description
        end
    },
}
