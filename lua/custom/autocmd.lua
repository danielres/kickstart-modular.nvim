vim.api.nvim_create_autocmd(
  -- { "FocusLost", "ModeChanged", "TextChanged", "BufEnter" },
  { 'BufLeave', 'FocusLost', 'ModeChanged' },
  { desc = 'autosave', pattern = '*', command = 'silent! update' }
)
