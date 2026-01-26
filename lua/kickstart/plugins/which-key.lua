-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
      },

      -- Document existing key chains
      spec = {
        { '<leader>a', group = '[A]i' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]irenv' },
        { '<leader>g', group = '[G]it' },
        { '<leader>h', group = '[H]aunt' },
        { '<leader>gh', group = '[H]unk', mode = { 'n', 'v' } },
        { '<leader>gG', group = '[G]itHub', mode = { 'n', 'v' } },
        { '<leader>s', group = '[S]earch' },
        { '<leader><tab>', group = 'Tabs' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>u', group = '[U]i' },
        { '<leader>w', proxy = '<c-w>', desc = '[W]indow' },
        { '<c-w>c', desc = '[C]lose window' },
        { '<leader><leader>', group = '...Extra' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
