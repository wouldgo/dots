local options = {
  updatetime = 50,
  nu = true,
  clipboard = 'unnamedplus',
  mouse = '',
  guicursor = '',
  colorcolumn = '100',
  cmdheight = 1,
  showmode = false,
  --backup = false,                          -- creates a backup file
  --completeopt = {                          -- mostly just for cmp
  --  'menuone',
  --  'noselect'
  --},
  --conceallevel = 0,                        -- so that `` is visible in markdown files
  --fileencoding = 'utf-8',                  -- the encoding written to a file
  --hidden = true,                           -- required to keep multiple buffers and open multiple buffers
  --hlsearch = false,                        -- no highlight all matches on previous search pattern
  --incsearch = true,
  --ignorecase = true,                       -- ignore case in search patterns
  --pumheight = 10,                          -- pop up menu height
  --showtabline = 2,                         -- always show tabs
  --smartcase = true,                        -- smart case
  --smartindent = true,                      -- make indenting smarter again
  --splitbelow = true,                       -- force all horizontal splits to go below current window
  --splitright = true,                       -- force all vertical splits to go to the right of current window
  --swapfile = false,                        -- creates a swapfile
  --termguicolors = true,                    -- set term gui colors (most terminals support this)
  --timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  --writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  --expandtab = true,                        -- convert tabs to spaces
  --shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  --tabstop = 2,                             -- insert 2 spaces for a tab
  --softtabstop = 2,
  --cursorline = true,                       -- highlight the current line
  --number = true,                           -- set numbered lines
  --relativenumber = false,                  -- set relative numbered lines
  --numberwidth = 4,                         -- set number column width to 2 {default 4}
  --signcolumn = 'yes',                      -- always show the sign column, otherwise it would shift the text each time
  --wrap = false,                            -- display lines as one long line
  --scrolloff = 8,                           -- is one of my fav
  --sidescrolloff = 8,
  --guifont = 'monospace:h17',               -- the font used in graphical neovim applications
  --errorbells = false,
  --undodir = vim.fn.stdpath('config') .. '/undodir',
  --undofile = true,                         -- enable persistent undo
}

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append 'c'
vim.opt.isfname:append '@-@'

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd 'set whichwrap+=<,>,[,],h,l'

vim.g.mapleader = ','
