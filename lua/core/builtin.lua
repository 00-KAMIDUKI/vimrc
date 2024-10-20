vim.lsp.set_log_level 'ERROR'

vim.diagnostic.config {
  signs = {
    text = { "", "", "", "󰌵", },
  },
  virtual_text = {},
  severity_sort = true,
}

vim.filetype.add {
  pattern = {
    ['${XDG_CONFIG_HOME}/hypr/.*.conf'] = 'hyprlang',
  },
  extension = {
    hl = 'hyprlang',
    rasi = 'rasi',
    glsl = 'glsl',
    plymouth = 'dosini',
  },
}
