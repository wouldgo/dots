local telescope_builtin_loaded, telescope_builtin = pcall(require, 'telescope.builtin')

if telescope_builtin_loaded then

  vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, {})
  vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, {})
  vim.keymap.set('n', '<leader>ps', function()
    telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
  end)
  vim.keymap.set('n', '<leader>vh', telescope_builtin.help_tags, {})

end
