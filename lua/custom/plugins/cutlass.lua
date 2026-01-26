-- Prevents deletion from writing into registers
-- 'm' is now used for 'move' (cut)

return {
  'svermeulen/vim-cutlass',
  config = function()
    -- stylua: ignore
    vim.keymap.set('n', 'm', 'd',   { noremap = true, desc = '[M]ove (cut)' })
    vim.keymap.set('x', 'm', 'd',   { noremap = true, desc = '[M]ove (cut)' })
    vim.keymap.set('n', 'mm', 'dd', { noremap = true, desc = '[M]ove (cut) line ' })
    vim.keymap.set('n', 'M', 'D',   { noremap = true, desc = '[M]ove (cut) to eol' })
  end,
}
