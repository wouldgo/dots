local nord_loaded, nord = pcall(require, 'nord')

if nord_loaded then
  vim.g.nord_contrast = true
  vim.g.nord_disable_background = true

  vim.cmd[[colorscheme nord]]
end
