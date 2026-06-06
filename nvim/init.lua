require 'core.options'
require 'core.keymaps'
require 'core.snippets'
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, {
        bufnr = args.buf,
      })
    end
  end,
})

require('lazy').setup 'plugins'
