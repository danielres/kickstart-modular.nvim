return {
  'folke/snacks.nvim',
  opts = {
    styles = {
      -- use entire screen space
      lazygit = { width = 0, height = 0 },
      terminal = { width = 0, height = 0 },
      scratch = { width = 0, height = 0 },
    },
    lazygit = {
      configure = true,
      theme_path = vim.fs.normalize(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'),
    },
  },
  keys = {
    {
      '<leader>ba',
      function()
        Snacks.bufdelete.all()
      end,
      desc = 'Delete all buffers',
    },
    {
      '<leader><leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'Explorer Snacks (root dir)',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open(require('snacks').config.lazygit)
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
  },
}
