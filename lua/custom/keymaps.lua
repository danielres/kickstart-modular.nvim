-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Code
vim.keymap.set('n', '<localleader>l', '<cmd>LspInfo<cr>', { desc = 'LspInfo' })
vim.keymap.set('n', '<localleader>m', '<cmd>Mason<cr>', { desc = 'Mason' })
vim.keymap.set('n', '<leader>cl', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- Commenting
vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- Better up/down (moves by visible lines, also when wrap is on)
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Save buffer
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = '[S]ave' })
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<leader>bs', '<cmd>w<cr><esc>', { desc = '[S]ave' })
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<leader><leader>s', '<cmd>w<cr><esc>', { desc = '[S]ave' })

-- Quit
vim.keymap.set('n', '<leader><leader>q', '<cmd>qa<cr>', { desc = '[Q]uit All' })

-- Tabs
vim.keymap.set('n', '<leader><Tab>o', '<Cmd>tabonly<CR>', { desc = 'Close [O]ther Tabs' })
vim.keymap.set('n', '<leader><Tab>[', '<Cmd>tabprevious<CR>', { desc = 'Previous Tab' })
vim.keymap.set('n', '<leader><Tab>]', '<Cmd>tabnext<CR>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><Tab><Tab>', '<Cmd>tabnext<CR>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><Tab>n', '<Cmd>tabnew<CR>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><Tab>d', '<Cmd>tabclose<CR>', { desc = 'Close Tab' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<Up>', '<cmd>resize +6<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<Down>', '<cmd>resize -6<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -8<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +8<cr>', { desc = 'Increase Window Width' })

-- Window navigation
nmap('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
nmap('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
nmap('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
nmap('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

-- Buffers
nmap('<S-h>', '<cmd>bprevious<cr>', 'Prev Buffer')
nmap('<S-l>', '<cmd>bnext<cr>', 'Next Buffer')
nmap('[b', '<cmd>bprevious<cr>', 'Prev Buffer')
nmap(']b', '<cmd>bnext<cr>', 'Next Buffer')
nmap('<leader>bb', '<cmd>e #<cr>', 'Switch to Other [B]uffer')

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
end, { desc = 'mini.files (cwd)' })

vim.keymap.set('n', '<leader>e', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
end, { desc = 'mini.files' })

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
