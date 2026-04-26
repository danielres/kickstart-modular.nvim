return {
  'nvim-mini/mini.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = '*',

  -- CONFIG --------------------------------------------------------------------

  config = function()
    local MiniFiles = require 'mini.files'

    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    require('mini.bracketed').setup()
    require('mini.clue').setup()
    require('mini.comment').setup {
      mappings = {
        textobject = 'c',
      },
    }
    MiniFiles.setup {
      windows = { preview = true, width_preview = 75 },
      mappings = { close = '<Esc>' },
      options = { permanent_delete = false },
    }

    local files_grug_far_replace = function()
      local entry = MiniFiles.get_fs_entry()
      if not entry then
        return
      end

      local prefills = { paths = vim.fs.dirname(entry.path) }
      local grug_far = require 'grug-far'

      if not grug_far.has_instance 'explorer' then
        grug_far.open {
          instanceName = 'explorer',
          prefills = prefills,
          staticTitle = 'Find and Replace from Explorer',
        }
      else
        grug_far.get_instance('explorer'):open()
        -- Update paths without clearing the current search/replace fields.
        grug_far.get_instance('explorer'):update_input_values(prefills, false)
      end
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        vim.keymap.set('n', 'gs', files_grug_far_replace, {
          buffer = args.data.buf_id,
          desc = 'Search in directory',
        })
      end,
    })

    require('mini.hipatterns').setup {
      -- stylua: ignore
      highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack =  { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
        todo =  { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        note =  { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    }
    require('mini.indentscope').setup {
      symbol = '▏',
    }
    require('mini.move').setup()
    require('mini.pairs').setup()
    require('mini.sessions').setup {
      autoread = true,
    }

    require('mini.surround').setup {
      -- stylua: ignore
      mappings = {
        add       = 'gsa', -- Add surrounding in Normal and Visual modes
        delete    = 'gsd', -- Delete surrounding
        highlight = 'gsh', -- Highlight surrounding
        replace   = 'gsr', -- Replace surrounding
      },
    }
  end,
}
