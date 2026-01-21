return {
  'Wansmer/treesj',
  keys = {
    { '<leader>ct', '<cmd>TSJToggle<CR>', desc = 'TS Join: Toggle' },
    { '<leader>cj', '<cmd>TSJoin<CR>', desc = 'TS Join: Join' },
    { '<leader>cs', '<cmd>TSSplit<CR>', desc = 'TS Join: Split' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({--[[ your config ]]})
  end,
}
