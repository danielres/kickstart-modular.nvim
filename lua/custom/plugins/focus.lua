return {
  'nvim-focus/focus.nvim',
  version = '*',

  config = function()
    require('focus').setup {
      enable = true, -- Enable module
      commands = true, -- Create Focus commands
      ui = {
        hybridnumber = true, -- Display hybrid line numbers in the focussed window only
      },
    }
  end,
}
