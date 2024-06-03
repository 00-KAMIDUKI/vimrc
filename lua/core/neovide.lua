if not vim.g.neovide then
  return
end

local candidate_fonts = {
  os.getenv 'XDG_BACKEND' == 'wayland' and {
    face = 'JetBrainsMono Nerd Font Propo,LXGW WenKai Mono:h12.5'
  } or {
    face = 'Firacode Nerd Font:h9'
  },
  { face = 'Maple Mono,JetBrainsMono Nerd Font Propo,LXGW WenKai Mono:h12.5', linespace = -1 },
  { face = 'FantasqueSansM Nerd Font Propo,LXGW WenKai Mono:h15.4', linespace = -1 },
  { face = 'CodeNewRoman Nerd Font:h14.71',  },
  { face = '' },
}

local g_font_idx = 0

local function set_font()
  vim.o.guifont = candidate_fonts[g_font_idx + 1].face
  vim.o.linespace = candidate_fonts[g_font_idx + 1].linespace
end

set_font()

vim.opt.winbl = 68

vim.g.neovide_scale_factor = 1.00
vim.g.neovide_transparency = 0.73
vim.g.neovide_scroll_animation_length = 0.14
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_opacity = 220.0
vim.g.neovide_cursor_vfx_particle_lifetime = 2.0
vim.g.neovide_cursor_vfx_particle_density = 8.5
vim.g.neovide_cursor_vfx_particle_speed = 9.2
vim.g.neovide_cursor_vfx_particle_phase = 2.0
vim.g.neovide_cursor_vfx_particle_curl = 0.3
vim.g.neovide_remember_window_size = false
vim.g.neovide_remember_window_position = false

vim.keymap.set('n', '<D-CR>', require 'utils.spawn_term', { desc = 'Spawn Terminal' })

vim.keymap.set('n', '<C-->', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05
end, { desc = 'Zoom Out' })
vim.keymap.set('n', '<C-=>', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05
end, { desc = 'Zoom In' })

vim.keymap.set('n', '<C-3>', function()
  local transparency = vim.g.neovide_transparency;
  if transparency < 1 then vim.g.neovide_transparency = transparency + 0.01 end
end, { desc = 'Increase Transparency' })
vim.keymap.set('n', '<C-4>', function()
  local transparency = vim.g.neovide_transparency;
  if transparency > 0 then vim.g.neovide_transparency = transparency - 0.01 end
end, { desc = 'Decrease Transparency' })

vim.keymap.set('n', '<leader>3', function()
  g_font_idx = (g_font_idx + 1) % #candidate_fonts
  set_font()
end, { desc = 'Next Font' })
vim.keymap.set('n', '<leader>2', function()
  g_font_idx = (g_font_idx - 1) % #candidate_fonts
  set_font()
end, { desc = 'Previous Font' })

vim.env.NEOVIDE = 1
