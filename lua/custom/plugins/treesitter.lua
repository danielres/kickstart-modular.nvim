return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = { 'c', 'lua', 'rust', 'elixir', 'heex', 'nix', 'svelte' },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
        scope_incremental = '<Tab>',
      },
    },
  },
}
