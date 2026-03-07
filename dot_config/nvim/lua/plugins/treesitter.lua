return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "vim",
                    "vimdoc",
                    "yaml"
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}