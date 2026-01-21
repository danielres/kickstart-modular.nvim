if vim.g.neovide then
  vim.o.termguicolors = true

  vim.o.winblend = 0
  vim.o.pumblend = 0
  vim.g.neovide_theme = 'dark' -- not "auto" on Wayland
  vim.opt.background = 'dark'
  vim.g.neovide_window_blurred = true
  vim.g.neovide_opacity = 0.9
  vim.g.neovide_normal_opacity = 0.9
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<C-=>', function()
    change_scale_factor(1.025)
  end)
  vim.keymap.set('n', '<C-->', function()
    change_scale_factor(1 / 1.025)
  end)
end

if vim.g.neovide then
  local function solid_bg()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    local bg = normal.bg or 0x1a1b26 -- fallback close to tokyonight
    vim.api.nvim_set_hl(0, 'Normal', { bg = bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = bg })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = bg })
  end
  vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, { callback = solid_bg })
end
