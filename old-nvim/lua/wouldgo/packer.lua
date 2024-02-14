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
	use 'wbthomason/packer.nvim'

  use 'shaunsingh/nord.nvim'
  use 'nvim-lualine/lualine.nvim'
  use {
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
  }

  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        icons = false,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/playground'

  use 'mbbill/undotree'

  use {
	  'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
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
