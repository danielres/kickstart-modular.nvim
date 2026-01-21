return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
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
    toggle = {},
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Create toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
        Snacks.toggle.zoom():map '<leader>uz'
      end,
    })
  end,
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
      '<leader>gGi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gGI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gGp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gGP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
  },
}
