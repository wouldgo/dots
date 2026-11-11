-- Leader must be set before lazy.nvim loads the plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.lazy")
-- VSCode-style keybindings, all in one place
require("config.keymaps")
