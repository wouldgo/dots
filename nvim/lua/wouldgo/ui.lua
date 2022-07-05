local nord_loaded, _ = pcall(require, 'nord')
local lualine_loaded, _ = pcall(require, 'lualine')

if nord_loaded then
  vim.g.nord_contrast = true
  vim.g.nord_borders = false
  vim.g.nord_disable_background = false
  vim.g.nord_italic = false

  require('nord').set()
end

if lualine_loaded then

  require('lualine').setup {
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
