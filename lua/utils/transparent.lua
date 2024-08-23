local transparent_bg_for = {
  'Normal',
  'NormalNC',
  'NormalFloat',
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

return {
  value = function() return value end,
  toggle = function()
    value = not value
    if not vim.g.neovide then
      storage.data().transparent_background = value
      storage.persist()
    end
    vim.cmd.colorscheme(vim.g.colors_name or require 'utils.storage'.data().colorscheme or 'default')
  end,
}
