-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Window navigation
nmap('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
nmap('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
nmap('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
nmap('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

-- Buffers
nmap('<C-q>', '<cmd>bdelete<CR>', 'Close current buffer')
nmap('<leader>bd', '<cmd>bdelete<CR>', 'Close current buffer')
nmap('<S-h>', '<cmd>bprevious<cr>', 'Prev Buffer')
nmap('<S-l>', '<cmd>bnext<cr>', 'Next Buffer')
nmap('[b', '<cmd>bprevious<cr>', 'Prev Buffer')
nmap(']b', '<cmd>bnext<cr>', 'Next Buffer')
nmap('<leader>bb', '<cmd>e #<cr>', 'Switch to Other Buffer')
nmap('<leader>`', '<cmd>e #<cr>', 'Switch to Other Buffer')

-- Centering
nmap('n', 'nzzzv', 'Keep search results centered (1/2)')
nmap('N', 'Nzzzv', 'Keep search results centered (2/2)')
nmap('<C-d>', '<C-d>zz', 'Keep cursor centered when scrolling (1/2)')
nmap('<C-u>', '<C-u>zz', 'Keep cursor centered when scrolling (2/2)')

-- Selection
vim.keymap.set('v', 'ag', '<Esc>ggVG', { desc = 'Select entire document' })
vim.keymap.set('n', 'gp', function()
  vim.cmd 'normal! `[v`]'
end, { desc = 'Select last change/paste' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
