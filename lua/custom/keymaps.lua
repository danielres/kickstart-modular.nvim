-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-q>', '<cmd>bdelete<CR>', { desc = 'Close current buffer' })

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Keep search results centered (1/2)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Keep search results centered (2/2)' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Keep cursor centered when scrolling (1/2)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Keep cursor centered when scrolling (2/2)' })
vim.keymap.set('v', 'ag', '<Esc>ggVG', { desc = 'Select entire document' })

vim.keymap.set('n', 'gp', function()
  vim.cmd 'normal! `[v`]'
end, { desc = 'Select last change/paste' })

-- EXPLORERS ---------------------------------------

vim.keymap.set('n', '<leader>E', function()
  require('mini.files').open()
end, { desc = 'Open mini.files (cwd)' })

vim.keymap.set('n', '<leader>e', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
end, { desc = 'Open mini.files (Directory of Current File)' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- AUTOCOMMANDS -------------------------------------

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
