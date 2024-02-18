local lualine_loaded, lualine = pcall(require, 'lualine')

if lualine_loaded then

  lualine.setup {
    options = {
      theme = 'nord',
      icons_enabled = false,
      component_separators = {
        left = '|',
        right = '|'
      },
      section_separators = {
        left = '|',
        right = '|'
      },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode', 'buffers'},
      lualine_b = {'diagnostics'},
      lualine_c = {},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'filename'},
      lualine_z = {'progress', 'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }

end
