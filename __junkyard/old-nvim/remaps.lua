

vim.cmd 'set whichwrap+=<,>,[,],h,l'

vim.g.mapleader = ','

--Workspaces creation/navigation
vim.keymap.set('n', '<C-a>', '<C-w>')

vim.keymap.set('n', '<C-a>|', '<C-w>v', {remap = true})
vim.keymap.set('n', '<C-a>-', '<C-w>s', {remap = true})

vim.keymap.set('n', '<Esc>[1;3A', '<C-a>k', {remap = true})
vim.keymap.set('n', '<Esc>[1;3B', '<C-a>j', {remap = true})
vim.keymap.set('n', '<Esc>[1;3D', '<C-a>h', {remap = true})
vim.keymap.set('n', '<Esc>[1;3C', '<C-a>l', {remap = true})
