local languages = { 'c', 'lua', 'rust', 'elixir', 'heex', 'ex' }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      ensure_installed = languages,
      fold = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
        },
      },
    },
  },
}
