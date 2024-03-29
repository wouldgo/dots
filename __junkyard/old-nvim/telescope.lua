local telescope_loaded, _ = pcall(require, 'telescope')

if telescope_loaded then

  require('telescope').setup{
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key"
        }
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
      find_files = {
        disable_devicons = true
      },
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
    }
  }

  vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
  vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
  vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
  vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
end
