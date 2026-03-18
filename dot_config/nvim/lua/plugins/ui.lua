return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "dracula",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                offsets = {
                    {
                        filetype = "oil",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "center",
                    },
                },
            },
        },
        keys = {
            { "<leader>bp", "<cmd>BufferLineCyclePrev<CR>",        desc = "Prev buffer" },
            { "<leader>bn", "<cmd>BufferLineCycleNext<CR>",        desc = "Next buffer" },
            { "<leader>bd", "<cmd>bdelete<CR>",                    desc = "Delete buffer" },
            { "<leader>bD", "<cmd>bdelete!<CR>",                   desc = "Force delete buffer" },
            { "<S-h>",      "<cmd>BufferLineCyclePrev<CR>",        desc = "Prev buffer" },
            { "<S-l>",      "<cmd>BufferLineCycleNext<CR>",        desc = "Next buffer" },
            { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>",      desc = "Close other buffers" },
            { "<leader>br", "<cmd>BufferLineCloseRight<CR>",       desc = "Close buffers to the right" },
            { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>",        desc = "Close buffers to the left" },
            { "<leader>1",  "<cmd>BufferLineGoToBuffer 1<CR>",     desc = "Go to buffer 1" },
            { "<leader>2",  "<cmd>BufferLineGoToBuffer 2<CR>",     desc = "Go to buffer 2" },
            { "<leader>3",  "<cmd>BufferLineGoToBuffer 3<CR>",     desc = "Go to buffer 3" },
            { "<leader>4",  "<cmd>BufferLineGoToBuffer 4<CR>",     desc = "Go to buffer 4" },
            { "<leader>5",  "<cmd>BufferLineGoToBuffer 5<CR>",     desc = "Go to buffer 5" },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "|" },
                scope = { enabled = true },
            })
        end,
    },
    { "folke/which-key.nvim",  opts = {} },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle<cr>",                   desc = "Toggle Trouble" },
            { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
        { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document diagnostics" },
        },
        opts = {},
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts    = { open_mapping = [[<C-\>]], direction = "horizontal", size = 15 },
    },

}
