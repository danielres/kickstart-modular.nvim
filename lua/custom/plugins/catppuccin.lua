return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {},

  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      color_overrides = {
        all = {
          -- DEFAULTS --------------------
          -- rosewater = '#f5e0dc',
          -- flamingo = '#f2cdcd',
          -- pink = '#f5c2e7',
          -- mauve = '#cba6f7',
          -- red = '#f38ba8',
          -- maroon = '#eba0ac',
          -- peach = '#fab387',
          -- yellow = '#f9e2af',
          -- green = '#a6e3a1',
          -- teal = '#94e2d5',
          -- sky = '#89dceb',
          -- sapphire = '#74c7ec',
          -- blue = '#89b4fa',
          -- lavender = '#b4befe',
          -- text = '#cdd6f4',
          -- subtext1 = '#bac2de',
          -- subtext0 = '#a6adc8',
          -- overlay2 = '#9399b2',
          -- overlay1 = '#7f849c',
          -- overlay0 = '#6c7086',
          -- surface2 = '#585b70',
          -- surface1 = '#45475a',
          -- surface0 = '#313244',
          -- base = '#1e1e2e',
          -- mantle = '#181825',
          -- crust = '#11111b',

          -- CUSTOM --------------------
          flamingo = '#f2cdcd',
          pink = '#f5ceea',
          mauve = '#d1b2f7',
          red = '#f3a9bc',
          maroon = '#ebb7be',
          peach = '#fac9ac',
          yellow = '#f9e2af',
          green = '#ace3a7',
          teal = '#94e2d5',
          sky = '#99deeb',
          sapphire = '#8eceec',
          blue = '#89b4fa',
          lavender = '#b4befe',
          base = '#191a24',
        },
      },

      custom_highlights = function(colors)
        return {
          Normal = { bg = '#151620' },
        }
      end,
    }

    vim.cmd.colorscheme 'catppuccin'
  end,
}
