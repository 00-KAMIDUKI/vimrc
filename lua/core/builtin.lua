vim.lsp.set_log_level 'ERROR'

vim.diagnostic.config {
  signs = {
    text = { "", "", "", "󰌵", },
  },
  virtual_text = {},
  severity_sort = true,
}
