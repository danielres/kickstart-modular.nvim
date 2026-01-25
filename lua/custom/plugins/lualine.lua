return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      sections = {
        lualine_a = {
          -- Custom component for macro recording feedback
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg ~= '' then
                return '@' .. reg
              end
              return ''
            end,
            color = { fg = '#ffffff', bg = '#ff0000' }, -- White text on red background
          },
          'mode',
        },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
}
