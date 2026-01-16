return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    color_overrides = {},
  },

  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
    }
  end,
}
