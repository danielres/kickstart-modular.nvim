return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      -- use entire screen space
      lazygit = { width = 0, height = 0 },
      scratch = { width = 0, height = 0 },
      terminal = {
        bo = {
          filetype = 'snacks_terminal',
        },
        wo = {},
        stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
        keys = {
          -- Add window navigation keys
          ['<C-h>'] = {
            function()
              vim.cmd 'stopinsert'
              vim.cmd 'wincmd h'
            end,
            mode = 't',
          },
          ['<C-j>'] = {
            function()
              vim.cmd 'stopinsert'
              vim.cmd 'wincmd j'
            end,
            mode = 't',
          },
          ['<C-k>'] = {
            function()
              vim.cmd 'stopinsert'
              vim.cmd 'wincmd k'
            end,
            mode = 't',
          },
          ['<C-l>'] = {
            function()
              vim.cmd 'stopinsert'
              vim.cmd 'wincmd l'
            end,
            mode = 't',
          },
          ['<C-/>'] = {
            function()
              vim.cmd 'stopinsert'
              Snacks.terminal.toggle()
            end,
            mode = 't',
          },
          gf = function(self)
            local f = vim.fn.findfile(vim.fn.expand '<cfile>', '**')
            if f == '' then
              Snacks.notify.warn 'No file under cursor'
            else
              self:hide()
              vim.schedule(function()
                vim.cmd('e ' .. f)
              end)
            end
          end,
          term_normal = {
            '<esc>',
            function(self)
              self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
              if self.esc_timer:is_active() then
                self.esc_timer:stop()
                vim.cmd 'stopinsert'
              else
                self.esc_timer:start(200, 0, function() end)
                return '<esc>'
              end
            end,
            mode = 't',
            expr = true,
            desc = 'Double escape to normal mode',
          },
        },
      },
    },
    lazygit = {
      configure = true,
      theme_path = vim.fs.normalize(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'),
    },
    toggle = {},
    key,
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
        -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        -- Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
        Snacks.toggle.zoom():map '<leader>bz'
      end,
    })
  end,
  keys = {
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = '[D]elete',
    },
    {
      '<leader>bo',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'Delete [O]ther',
    },
    {
      '<leader>ba',
      function()
        Snacks.bufdelete.all()
      end,
      desc = 'Delete [A]ll',
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
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Scratch',
    },
    {
      '<leader><leader>.',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<C-/>',
      function()
        Snacks.terminal.toggle()
      end,
      desc = '[T]oggle terminal',
    },
  },
}
