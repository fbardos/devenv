return {
    "nvim-treesitter/nvim-treesitter",  -- treesitter
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    -- with the rewrite of nvim-treesitter, ensure_installed
    -- has no effect anymore. installation of the languages
    -- happen directly in the Dockerfile
}
