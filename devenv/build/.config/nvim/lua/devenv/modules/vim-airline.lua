return {
    "vim-airline/vim-airline",  -- nvim footer
    dependencies = {
        "vim-airline/vim-airline-themes",
        "tpope/vim-fugitive",  -- git integration in airline
    },
    config = function()

        --  Show, on which class/method/... the cursor currently is
        vim.g["airline#extensions#tagbar#enabled"] = 1

        --  Show full path (inclusive class name) of current tag
        vim.g["airline#extensions#tagbar#flags"] = "f"

        -- Enable powerline fonts (incl. arrows instead of rectangle endings)
        vim.g["airline_powerline_fonts"] = 1

        -- Do now show git info about lines added/deleted/changed
        vim.g["airline#extensions#hunks#enabled"] = 0
        vim.g["airline#extensions#branch#enabled"] = 1

        -- Modify section Z (line/col number) --> needs less space
        vim.g["airline_section_z"] = "%l/%L,%c"
        vim.g["airline_section_warning"] = "%{airline#util#wrap(airline#extensions#nvimlsp#get_warning(),0)}"
        vim.g["airline_section_error"] = "%{airline#util#wrap(airline#extensions#nvimlsp#get_error(),0)}"

    end,
}
