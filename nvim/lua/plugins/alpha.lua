return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    local art_files = vim.fn.glob(vim.fn.stdpath 'config' .. '/lua/art/*.lua', false, true)

    if #art_files > 0 then
      math.randomseed(vim.loop.hrtime())

      local file = art_files[math.random(#art_files)]

      local module = file:gsub(vim.fn.stdpath 'config' .. '/lua/', ''):gsub('%.lua$', ''):gsub('/', '.')

      local header = require(module)

      dashboard.section.header.val = header.val
      dashboard.section.header.opts.hl = header.opts.hl
    end

    dashboard.section.buttons.val = {
      dashboard.button('e', '  New file', ':ene<CR>'),
      dashboard.button('f', '󰈞  Find file', ':Telescope find_files<CR>'),
      dashboard.button('r', '󰄉  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '󰈬  Find word', ':Telescope live_grep<CR>'),
      dashboard.button('c', '  Config', ':e ~/.config/nvim/init.lua<CR>'),
      dashboard.button('q', '󰗼  Quit', ':qa<CR>'),
    }

    dashboard.section.footer.val = {
      '',
      ' Arch 󰄛 Yloryth',
    }

    alpha.setup(dashboard.opts)
  end,
}
