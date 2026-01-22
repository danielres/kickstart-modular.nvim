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
      '<leader>wq',
      function()
        require('quicker').toggle()
      end,
      desc = 'Toggle [Q]uickfix',
    },
    {
      '<leader>wl',
      function()
        require('quicker').toggle { loclist = true }
      end,
      desc = 'Toggle [L]oclist',
    },
  },
}
