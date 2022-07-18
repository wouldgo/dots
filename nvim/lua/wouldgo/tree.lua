local nvim_tree_loaded, _ = pcall(require, 'nvim-tree')

if nvim_tree_loaded then

  require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = 'u', action = 'dir_up' },
        },
      },
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = true,
        },
      },
    },
    filters = {
      dotfiles = true,
    },
  })
end
