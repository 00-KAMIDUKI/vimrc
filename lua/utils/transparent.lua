local transparent_bg_for = {
  'Normal',
  'NormalNC',
  'NormalFloat',
  'TabLine',
  'TabLineFill',
  'Pmenu',
}

local storage = require 'utils.storage'
local value = not vim.g.neovide and storage.data().transparent_background

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if not value then return end
    for _, name in ipairs(transparent_bg_for) do
      vim.cmd('hi! ' .. name .. ' guibg=none')
    end
  end,
  desc = 'Set transparent background for some highlight groups.',
})

---@type table<string, string | integer?>
local cache = {}

local function get_highlight(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function non_transparent_statusline()
  return get_highlight(storage.statusline_hl or 'StatusLine')
      or get_highlight 'StatusLine'
      or 'NONE'
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    cache = {}
  end,
})

return {
  value = function() return value end,
  toggle = function()
    value = not value
    if not vim.g.neovide then
      storage.data().transparent_background = value
      storage.persist()
    end
    require 'utils.reset_colorscheme' ()
  end,
  statusline_hl = {
    fg = function()
      if cache.default_fg == nil then
        cache.default_fg = value
            and get_highlight('Normal').fg
            or non_transparent_statusline().fg
      end
      return cache.default_fg
    end,
    bg = function()
      if cache.default_bg == nil then
        cache.default_bg = value
            and 'NONE'
            or non_transparent_statusline().bg
      end
      return cache.default_bg
    end
  },
}
