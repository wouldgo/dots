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
      icons_enabled = true,
      theme = 'nord',
      component_separators = { left = '⟪', right = '⟫'},
      section_separators = { left = '⟪', right = '⟫'},
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = false,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
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
