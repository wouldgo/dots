return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    -- Language servers, debug adapters and formatters, installed on first start
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- language servers
        "bash-language-server",
        "eslint-lsp",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "rust-analyzer",
        "vtsls",
        "yaml-language-server",
        -- debug adapters
        "codelldb",
        "cpptools",
        "delve",
        "js-debug-adapter",
        -- formatters
        "goimports",
        "prettier",
        "shfmt",
        "stylua",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("gopls", {
        settings = {
          gopls = { buildFlags = { "-tags=test" } },
        },
      })

      -- C/C++: clangd finds compile_commands.json also in build/. An ESP-IDF
      -- project (it has sdkconfig) gets the clangd of esp-clang instead: it
      -- knows the Xtensa and RISC-V targets, and it asks the Espressif gcc for
      -- the system headers. esp-clang comes from idf_tools.py (chezmoi or the
      -- VSCode extension): the newest one wins.
      local espressif = vim.fs.normalize("~/.espressif/tools")
      local esp_clangd = vim.fn.glob(espressif .. "/esp-clang/*/esp-clang/bin/clangd", false, true)
      table.sort(esp_clangd)
      esp_clangd = esp_clangd[#esp_clangd]
      local function esp_root(buf)
        return esp_clangd and vim.fs.root(buf, "sdkconfig")
      end

      local clangd_root = vim.lsp.config.clangd.root_markers
      vim.lsp.config("clangd", {
        root_dir = function(buf, on_dir)
          if not esp_root(buf) then
            on_dir(vim.fs.root(buf, clangd_root) or vim.fn.getcwd())
          end
        end,
      })
      vim.lsp.config(
        "esp_clangd",
        vim.tbl_extend("force", vim.lsp.config.clangd, {
          cmd = {
            esp_clangd or "clangd",
            "--background-index",
            "--query-driver=" .. espressif .. "/**/bin/*-gcc",
          },
          root_dir = function(buf, on_dir)
            local root = esp_root(buf)
            if root then
              on_dir(root)
            end
          end,
        })
      )
      if vim.fn.executable("clangd") == 1 then
        vim.lsp.enable("clangd")
      end
      if esp_clangd then
        vim.lsp.enable("esp_clangd")
      end

      vim.lsp.enable({
        "bashls",
        "eslint",
        "gopls",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "vtsls",
        "yamlls",
      })
    end,
  },
  {
    -- Completion and types for the nvim API while editing this config
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    opts = {
      -- Enter and Tab accept, Ctrl+Space opens the menu, Esc closes it
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        list = { selection = { preselect = true, auto_insert = false } },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
        rust = { "rustfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      default_format_opts = { lsp_format = "fallback" },
      -- Format on save only for Go, as the VSCode Go extension does;
      -- everything else formats on demand with Shift+Alt+F
      format_on_save = function(buf)
        if vim.bo[buf].filetype == "go" then
          return { timeout_ms = 1000 }
        end
      end,
    },
  },
}
