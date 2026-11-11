local opt = vim.opt

vim.g.have_nerd_font = true

opt.number = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.showmode = false
opt.scrolloff = 8
opt.smoothscroll = true
opt.wrap = false
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.winborder = "rounded"

-- editor.tabSize = 2; the real indentation of a file is detected by vim-sleuth
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.mouse = "a"
opt.mousemodel = "popup_setpos"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.confirm = true
opt.autoread = true
opt.updatetime = 250
opt.timeoutlen = 400

-- Shift+arrows select like VSCode: typing replaces the selection, plain arrows
-- drop it and Left/Right move across line ends (see also config/autocmds.lua)
opt.selectmode = "key"
opt.keymodel = { "startsel", "stopsel" }
opt.whichwrap:append("<,>,[,]")

-- After UiEnter: the clipboard provider is slow to probe at startup
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  float = { source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})
