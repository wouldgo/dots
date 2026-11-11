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
