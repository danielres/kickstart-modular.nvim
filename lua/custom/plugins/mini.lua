return {
  'nvim-mini/mini.nvim',
  version = '*',

  -- CONFIG --------------------------------------------------------------------

  config = function()
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    require('mini.clue').setup()
    require('mini.files').setup { windows = { preview = true, width_preview = 75 } }
    require('mini.hipatterns').setup {
      highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    }
    require('mini.move').setup()
    require('mini.pairs').setup()
    require('mini.sessions').setup {
      autoread = true,
    }

    require('mini.statusline').setup {
      use_icons = vim.g.have_nerd_font,
      section_location = function()
        return '%2l:%-2v'
      end,
    }

    require('mini.surround').setup {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
      },
    }
  end,
}
