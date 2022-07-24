local packer_bootstrap = false
local packer_install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
	packer_bootstrap = true
	vim.fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		packer_install_path,
	}
	vim.o.runtimepath = vim.fn.stdpath 'data' .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

local packer = require 'packer'

packer.startup({function(use)
	use('wbthomason/packer.nvim')
  use('shaunsingh/nord.nvim')
  use('nvim-lualine/lualine.nvim')
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use('nvim-treesitter/nvim-treesitter', {
    run = ':TSUpdate'
  })
  use 'neovim/nvim-lspconfig'
  use 'mbbill/undotree'
  use {
    'kyazdani42/nvim-tree.lua'
  }

  if packer_bootstrap then
		packer.sync()
	end
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})
