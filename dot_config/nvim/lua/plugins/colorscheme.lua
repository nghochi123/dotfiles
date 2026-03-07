return {
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("dracula").setup({
                transparent_bg = false,
                italic_comment = true,
            })
            vim.cmd.colorscheme("dracula")
            
            vim.api.nvim_set_hl(0, "Matchparen", { fg = "#ffb86c", bg = "#0091ff", bold = true})
        end,
    },
}