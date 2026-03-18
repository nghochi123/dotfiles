vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 7
opt.showmode = false

opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.swapfile = true
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 500
opt.wildmenu = true

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.history = 500

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    checker = { enabled = false },
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "netrwPlugin",
                "netrw",
            },
        },
    },
})

-- Automatically save files before running CMake commands
vim.api.nvim_create_autocmd("User", {
    pattern = "CMake*Pre",
    callback = function()
        vim.cmd("wa")
    end,
})

-- --------------------------------------------------------------------------
-- Keymaps (VSCode-familiar)
-- --------------------------------------------------------------------------

-- Comment with Ctrl+/
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Comment toggle line" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Comment toggle" })

-- Move lines with Alt+Up/Down
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate lines with Alt+Shift+Up/Down
vim.keymap.set("n", "<A-S-Down>", "<cmd>t .<CR>", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-S-Up>", "<cmd>t .-1<CR>", { desc = "Duplicate line up" })
vim.keymap.set("v", "<A-S-Down>", ":'<,'>t '><CR>gv", { desc = "Duplicate selection down" })
vim.keymap.set("v", "<A-S-Up>", ":'<,'>t '<-1<CR>gv", { desc = "Duplicate selection up" })

-- Tab / Shift+Tab to indent and keep selection
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent and reselect" })

