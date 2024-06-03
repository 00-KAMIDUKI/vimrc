return function()
  local term = vim.env['MY_TERM']
  local shell = 'fish'
  local neovide = vim.fn.environ()['NEOVIDE']
  vim.env['NEOVIDE'] = nil
  vim.system { term, '-e', shell, '-C', 'cd ' .. vim.fn.getcwd() }
  vim.env['NEOVIDE'] = neovide
end
