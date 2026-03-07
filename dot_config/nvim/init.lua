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

local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter-blob:none",
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