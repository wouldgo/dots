local mason_loaded, _ = pcall(require, 'mason')
local mason_lspconfig_loaded, _ = pcall(require, 'mason-lspconfig')
local lspconfig_loaded, _ = pcall(require, 'lspconfig')
print(mason_loaded)
print(mason_lspconfig_loaded)
print(lspconfig_loaded)


if mason_loaded and mason_lspconfig_loaded and lspconfig_loaded then
  require('mason').setup({
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗'
      }
    }
  })

  require('mason-lspconfig').setup({
    automatic_installation = true,
  })

  require('lspconfig').gopls.setup({
    cmd = { 'gopls', 'serve' },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  })
end
