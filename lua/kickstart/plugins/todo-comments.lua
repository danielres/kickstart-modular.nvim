-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      {
        '<leader>sta',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = '[A]ll (+notes...)',
      },
      {
        '<leader>stt',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = '[T]ODO + FIX',
      },
      { '<leader>stq', '<cmd>TodoQuickFix<cr>', desc = '-> [Q]uickfix', silent = true },
    },
  },
}
