return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Oil",
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
            { "<leader>e", function() require("oil").toggle_float() end, desc = "Toggle file explorer (float)" },
        },
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
                float = {
                    padding = 2,
                    max_width = 80,
                    max_height = 30,
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = "actions.select.v_split",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["q"] = "actions.close",
                },
            })
        end,
    },
}