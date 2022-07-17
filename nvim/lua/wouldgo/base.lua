local options = {
  guifont = 'monospace:h18',               -- the font used in graphical neovim applications
  updatetime = 50,
  errorbells = false,
  nu = true,
  clipboard = 'unnamedplus',
  mouse = '',
  guicursor = '',
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  colorcolumn = '100',
  cmdheight = 1,
  showmode = false,
  pumheight = 10,
  conceallevel = 0,
  fileencoding = 'utf-8',
  undofile = true,                         -- enable persistent undo
  undodir = vim.fn.stdpath('config') .. '/undodir',
  writebackup = true,
  backup = true,                          -- creates a backup file
  backupdir = vim.fn.stdpath('config') .. '/backupdir',

  --completeopt = {                          -- mostly just for cmp
  --  'menuone',
  --  'noselect'
  --},
  hlsearch = false,                        -- no highlight all matches on previous search pattern
  incsearch = true,
  ignorecase = true,                       -- ignore case in search patterns
  showtabline = 0,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)


  cursorline = false,                      -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 2,                         -- set number column width to 2 {default 4}
  signcolumn = 'yes',                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 4,                           -- is one of my fav
  sidescrolloff = 4,



}

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append 'c'
vim.opt.isfname:append '@-@'

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd 'set whichwrap+=<,>,[,],h,l'

vim.g.mapleader = ','
