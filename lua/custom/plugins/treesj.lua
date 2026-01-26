return {
  'Wansmer/treesj',
  keys = {
    { '<leader>cj', '<cmd>TSJToggle<CR>', desc = 'TS[J]oin Toggle' },
    -- { '<leader>cjj', '<cmd>TSJoin<CR>', desc = 'Join' },
    -- { '<leader>cjs', '<cmd>TSSplit<CR>', desc = 'Split' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({--[[ your config ]]})
  end,
}
