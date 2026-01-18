return {
  'monaqa/dial.nvim',
  recommended = true,
  desc = 'Increment and decrement numbers, dates, and more',
  keys = {
    {
      '<C-a>',
      function()
        return require('dial.map').inc_normal()
      end,
      expr = true,
      desc = 'Increment',
      mode = { 'n', 'v' },
    },
    {
      '<C-x>',
      function()
        return require('dial.map').dec_normal()
      end,
      expr = true,
      desc = 'Decrement',
      mode = { 'n', 'v' },
    },
    {
      'g<C-a>',
      function()
        return require('dial.map').inc_gnormal()
      end,
      expr = true,
      desc = 'Increment',
      mode = { 'n', 'x' },
    },
    {
      'g<C-x>',
      function()
        return require('dial.map').dec_gnormal()
      end,
      expr = true,
      desc = 'Decrement',
      mode = { 'n', 'x' },
    },
    -- Fixed: Removed expr = true for manipulate() calls
    {
      '<C-S-A>',
      function()
        require('dial.map').manipulate('increment', 'normal', nil, 10)
      end,
      desc = 'Increment by 10',
      mode = { 'n', 'v' },
    },
    {
      '<C-S-X>',
      function()
        require('dial.map').manipulate('decrement', 'normal', nil, 10)
      end,
      desc = 'Decrement by 10',
      mode = { 'n', 'v' },
    },
  },
  opts = function()
    local augend = require 'dial.augend'

    -- Keep your unique custom augends
    local logical_alias = augend.constant.new {
      elements = { '&&', '||' },
      word = false,
      cyclic = true,
    }

    local ordinal_numbers = augend.constant.new {
      elements = { 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth' },
      word = false,
      cyclic = true,
    }

    local weekdays = augend.constant.new {
      elements = { 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' },
      word = true,
      cyclic = true,
    }

    local months = augend.constant.new {
      elements = { 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' },
      word = true,
      cyclic = true,
    }

    local capitalized_boolean = augend.constant.new {
      elements = { 'True', 'False' },
      word = true,
      cyclic = true,
    }

    return {
      groups = {
        default = {
          -- Only add your custom augends - defaults are already included
          ordinal_numbers,
          weekdays,
          months,
          capitalized_boolean,
          logical_alias,
          -- Add hex color support globally
          augend.hexcolor.new { case = 'lower' },
          augend.hexcolor.new { case = 'upper' },
        },
        typescript = {
          augend.constant.new { elements = { 'let', 'const' } },
        },
        css = {
          augend.hexcolor.new { case = 'lower' },
          augend.hexcolor.new { case = 'upper' },
        },
        markdown = {
          augend.constant.new { elements = { '[ ]', '[x]' }, word = false, cyclic = true },
          augend.misc.alias.markdown_header,
        },
        json = {
          augend.semver.alias.semver,
        },
        lua = {
          augend.constant.new { elements = { 'and', 'or' }, word = true, cyclic = true },
        },
        python = {
          augend.constant.new { elements = { 'and', 'or' } },
        },
      },
    }
  end,
  config = function(_, opts)
    require('dial.config').augends:register_group(opts.groups)
  end,
}
