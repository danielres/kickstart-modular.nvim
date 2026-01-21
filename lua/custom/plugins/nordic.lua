return {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- require('nordic').load()
    require('nordic').setup {
      on_palette = function(palette)
        palette.black0 = '#000000'
        -- palette.gray0 = '#191D24'
        palette.gray0 = '#20242b'
      end,
      integrations = {
        indent_blankline = true,
      },
    }
    -- vim.cmd.colorscheme 'nordic'
  end,
}
