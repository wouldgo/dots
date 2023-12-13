local lsp_zero_loaded, lsp_zero = pcall(require, 'lsp-zero')

if lsp_zero_loaded then
  local mason = require('mason')
  local mason_lsp = require('mason-lspconfig')
  local cmp = require('cmp')
  local cmp_action = lsp_zero.cmp_action()

  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
  end)

  mason.setup({})
  mason_lsp.setup({
    ensure_installed = {
      'grammarly',
      'bashls',
      'dockerls',
      'ansiblels',
      'sqlls',
      'jsonls',
      'gopls',
      'tsserver',
      'eslint',
      'rust_analyzer',
      'jdtls',
      'lemminx',
      'yamlls',
    },
    handlers = {
      lsp_zero.default_setup,
    },
  })

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({select = false}),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      -- Navigate between snippet placeholder
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),

      -- Scroll up and down in the completion documentation
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    })
  })

end
