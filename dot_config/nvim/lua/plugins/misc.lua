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
        ensure_installed = { "clangd", "pyright", "ruff", "lua_ls" },
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
          map("<leader>rn", vim.lsp.buf.rename,         "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
          map("<leader>D",  tb.diagnostics,             "Workspace diagnostics")
          map("[d",         vim.diagnostic.goto_prev,   "Previous diagnostic")
          map("]d",         vim.diagnostic.goto_next,   "Next diagnostic")
          map("<leader>ld", vim.diagnostic.open_float,  "Line diagnostic")
        end,
      })

      -- Extend default capabilities with nvim-cmp completions
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure servers via the new vim.lsp.config API (nvim 0.11+)
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("ruff",    { capabilities = capabilities })
      vim.lsp.config("lua_ls",  {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
      })

      -- Enable all configured servers
      vim.lsp.enable({ "clangd", "pyright", "ruff", "lua_ls" })
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
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",   -- snippet collection
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible()          then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible()          then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          { name = "buffer"   },
          { name = "path"     },
        }),
      })
    end,
  },
  -- --------------------------------------------------------------------------
  -- Formatting (conform.nvim)
  -- --------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp    = { "clang_format" },
        c      = { "clang_format" },
        python = { "ruff_format", "ruff_organize_imports" },
        lua    = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format buffer",
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- Linting (nvim-lint)
  -- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        cpp    = { "clangtidy" },
        python = { "ruff" },
      }
      -- Trigger linting on save / buffer enter
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- CMake integration
  -- --------------------------------------------------------------------------
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        cmake_build_before_run = true,
        cmake_executor = {
            name = "toggleterm",
            opts = {
                direction = "horizontal", -- or "float"
                close_on_exit = false,
                }
            },
        cmake_runner = {
            name = "toggleterm",
            opts = {
                direction = "horizontal",
                singleton = true, -- Reuses the same terminal window
            }
        },
    },
    keys = {
      { "<leader>mb", "<cmd>CMakeBuild<cr>",  desc = "CMake: Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>",    desc = "CMake: Run" },
      { "<leader>md", "<cmd>CMakeDebug<cr>",  desc = "CMake: Debug" },
      { "<leader>mc", "<cmd>CMakeClean<cr>",  desc = "CMake: Clean" },
      { "<leader>ms", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake: Select build type" },
    },
  },

  -- --------------------------------------------------------------------------
  -- Debugging (DAP)
  -- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",   -- Python debug adapter
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
      require("dap-python").setup("python")   -- uses the active venv python

      -- C++ / C debug adapter (lldb via codelldb — install via Mason)
      dap.adapters.codelldb = {
        type    = "server",
        port    = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args    = { "--port", "${port}" },
        },
      }
      dap.configurations.cpp = {
        {
          name    = "Launch (codelldb)",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd            = "${workspaceFolder}",
          stopOnEntry    = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Open/close UI automatically
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end

      -- Keymaps
      vim.keymap.set("n", "<F5>",        dap.continue,          { desc = "DAP: Continue" })
      vim.keymap.set("n", "<F10>",       dap.step_over,         { desc = "DAP: Step over" })
      vim.keymap.set("n", "<F11>",       dap.step_into,         { desc = "DAP: Step into" })
      vim.keymap.set("n", "<F12>",       dap.step_out,          { desc = "DAP: Step out" })
      vim.keymap.set("n", "<leader>db",  dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB",  function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "DAP: Conditional breakpoint" })
      vim.keymap.set("n", "<leader>du",  dapui.toggle,          { desc = "DAP: Toggle UI" })
    end,
  },
}
