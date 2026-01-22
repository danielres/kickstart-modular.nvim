return {
  'eero-lehtinen/oklch-color-picker.nvim',
  event = 'VeryLazy',
  version = '*',
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    {
      '<leader>cc',
      function()
        require('oklch-color-picker').pick_under_cursor()
      end,
      desc = '[C]olor pick under cursor',
    },
  },
  opts = {
    -- Note: requires separate binary, if the auto_download one doesn't work on nixos:
    -- 1) Install `oklch-color-picker` on nixos
    -- 2) Replace:
    --     ~/.local/share/vim-kickstart-modular/oklch-color-picker/oklch-color-picker
    --   with symlink to:
    --     ~/.nix-profile/bin/oklch-color-picker

    auto_download = false,
  },
}
