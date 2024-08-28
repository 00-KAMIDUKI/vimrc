if not vim.g.neovide then
  return
end

local candidate_fonts = {
  { face = 'JetBrainsMono NFP Thin,LXGW WenKai Mono:h15',        linespace = -1 },
  { face = 'JetBrainsMono NFP Light,LXGW WenKai Mono:h15',       linespace = -1 },
  { face = 'JetBrainsMono NFP,LXGW WenKai Mono:h15',             linespace = -1 },
  { face = 'JetBrainsMono NFP Thin,LXGW WenKai Mono:h12.5' },
  { face = 'Maple Mono,JetBrainsMono NFP,LXGW WenKai Mono:h12.5' },
}

local g_font_idx = 0

local function set_font()
  vim.o.guifont = candidate_fonts[g_font_idx + 1].face
  vim.o.linespace = candidate_fonts[g_font_idx + 1].linespace
end

set_font()

do
  vim.g.neovide_remember_window_size     = false
  vim.g.neovide_remember_window_position = false
end

local storage = require 'utils.storage'
local neovide = storage.data().neovide

if neovide then
  if neovide.global then
    vim.g.neovide_transparency            = neovide.global.transparency
    vim.g.neovide_scroll_animation_length = neovide.global.scroll_animation_length
    local cursor                          = neovide.global.cursor
    if cursor then
      local vfx = cursor.vfx
      if vfx then
        vim.g.neovide_cursor_vfx_mode    = vfx.mode
        vim.g.neovide_cursor_vfx_opacity = vfx.opacity
        local particle                   = vfx.particle
        if particle then
          vim.g.neovide_cursor_vfx_particle_lifetime = particle.lifetime
          vim.g.neovide_cursor_vfx_particle_density  = particle.density
          vim.g.neovide_cursor_vfx_particle_speed    = particle.speed
          vim.g.neovide_cursor_vfx_particle_phase    = particle.phase
          vim.g.neovide_cursor_vfx_particle_curl     = particle.curl
        end
      end
    end
    if neovide.option then
      vim.o.winblend = neovide.option.blend
    end
  end
end

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
