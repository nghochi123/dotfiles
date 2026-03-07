return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    {
        "kylechui/nvim-surround",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment toggle current line" },
            { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
        },
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "ethanholz/nvim-lastplace",
        lazy = false,
        config = function()
            require("nvim-lastplace").setup({
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = { "gitcommit", "gitrebase" },
            })
        end,
    },

    { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
}
