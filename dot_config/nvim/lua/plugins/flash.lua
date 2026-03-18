return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                -- Enhance the default f/F/t/T motions with flash labels
                char = { enabled = true },
                -- Use flash when doing search with / or ?
                search = { enabled = true },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash jump",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash treesitter select",
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Flash treesitter search",
            },
            {
                "<C-s>",
                mode = "c",
                function() require("flash").toggle() end,
                desc = "Toggle flash search",
            },
        },
    },
}
