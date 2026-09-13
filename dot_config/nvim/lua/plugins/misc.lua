return {
  -- --------------------------------------------------------------------------
  -- LSP — language servers
  -- --------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",           config = true },
      { "williamboman/mason-lspconfig.nvim" },
      { "j-hui/fidget.nvim",                opts = {} },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff" },
        automatic_installation = true,
      })

      -- Keymaps applied whenever any LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          local tb = require("telescope.builtin")
          map("gd",         tb.lsp_definitions,       "Go to definition")
          map("gD",         vim.lsp.buf.declaration,   "Go to declaration")
          map("gr",         tb.lsp_references,         "Go to references")
          map("gI",         tb.lsp_implementations,    "Go to implementation")
          map("gt",         tb.lsp_type_definitions,   "Go to type definition")
          map("K",          vim.lsp.buf.hover,          "Hover docs")
          map("<C-k>",      vim.lsp.buf.signature_help, "Signature help")
          map("<F2>",        vim.lsp.buf.rename,       "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,  "Code action")
        end,
      })

      -- Extend default capabilities with nvim-cmp completions
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure servers via the new vim.lsp.config API (nvim 0.11+)
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("ruff",    { capabilities = capabilities })

      -- Enable all configured servers
      vim.lsp.enable({ "pyright", "ruff" })
    end,
  },
  -- --------------------------------------------------------------------------
  -- Autocompletion
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer"   },
          { name = "path"     },
        }),
      })
    end,
  },
}
