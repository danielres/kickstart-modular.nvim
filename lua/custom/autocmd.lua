vim.api.nvim_create_autocmd(
  -- { "FocusLost", "ModeChanged", "TextChanged", "BufEnter" },
  { 'BufLeave', 'FocusLost', 'ModeChanged' },
  { desc = 'autosave', pattern = '*', command = 'silent! update' }
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
