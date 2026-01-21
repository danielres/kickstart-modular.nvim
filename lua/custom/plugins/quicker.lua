return {
  'stevearc/quicker.nvim',
  ft = 'qf',
  opts = {
    edit = {
      enabled = true,
      autosave = 'unmodified',
    },
  },
  keys = {
    {
      '<leader>uq',
      function()
        require('quicker').toggle()
      end,
      desc = 'Toggle [Q]uickfix',
    },
    {
      '<leader>ul',
      function()
        require('quicker').toggle { loclist = true }
      end,
      desc = 'Toggle [L]oclist',
    },
  },
}
