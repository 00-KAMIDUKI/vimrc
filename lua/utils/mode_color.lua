local lut = {
  n = 'Function',
  i = 'String',
  v = 'Keyword',
  V = 'Include',
  t = 'Label',
  c = 'Constant',
  R = '@variable.builtin',
  s = '@lsp.type.interface',
  [''] = '@variable.parameter'
}

return function()
  local hl = vim.api.nvim_get_hl(0, { name = lut[vim.fn.mode()] or 'DevIconBazel', link = false })
  vim.api.nvim_set_hl(0, 'ModeColor', {
    fg = hl.fg,
    bg = hl.bg,
  })
  vim.api.nvim_set_hl(0, 'ModeColorReverse', {
    fg = vim.api.nvim_get_hl(0, { name = 'CursorLine', link = false }).bg,
    bg = hl.fg,
  })
end
