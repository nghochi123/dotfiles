return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                -- Use noice for LSP progress/hover/signature
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search         = true,   -- classic bottom cmdline for search
                command_palette       = true,   -- position the cmdline and popupmenu together
                long_message_to_split = true,   -- long messages go to a split
                inc_rename            = false,
                lsp_doc_border        = true,   -- add a border to hover docs and signature help
            },
            routes = {
                -- Hide the "written" message on save
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        },
        keys = {
            { "<leader>nl", function() require("noice").cmd("last") end,    desc = "Noice last message" },
            { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice history" },
            { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss notifications" },
        },
    },

    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 3000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width  = function() return math.floor(vim.o.columns * 0.75) end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },
}
