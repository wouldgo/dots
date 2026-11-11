return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    -- Medium contrast, the same background as the Alacritty theme
    opts = { contrast = "" },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    -- Pickers (Ctrl+P, Ctrl+Shift+F, ...), file explorer, terminal and other small pieces
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true, replace_netrw = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          -- workbench.sideBar.location = right
          explorer = { hidden = true, layout = { layout = { position = "right" } } },
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
      terminal = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        close_command = function(buf)
          Snacks.bufdelete(buf)
        end,
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { globalstatus = true, component_separators = "", section_separators = "" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>g", group = "git" },
        -- Ctrl+W closes the editor like in VSCode: window commands live here
        { "<leader>w", proxy = "<C-w>", group = "windows" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
