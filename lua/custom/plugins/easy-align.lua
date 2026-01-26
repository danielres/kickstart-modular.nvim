return {
  'junegunn/vim-easy-align',

  config = function()
    -- Keymap options:
    -- 'noremap = false' (or omitting it) is crucial for <Plug> mappings
    local opts = { silent = true }

    -- Normal mode mapping: Start interactive EasyAlign for a motion/text object (e.g., gaip=)
    vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', opts)

    -- Visual mode mapping: Start interactive EasyAlign on the visual selection (e.g., vipga=)
    vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', opts)

    -- Optional: Live Interactive Mode mapping
    vim.keymap.set('n', 'gA', '<Plug>(LiveEasyAlign)', opts)
    vim.keymap.set('x', 'gA', '<Plug>(LiveEasyAlign)', opts)
  end,
}
