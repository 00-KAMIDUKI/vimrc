return function()
  vim.cmd.colorscheme(vim.g.colors_name
    or require 'utils.storage'.data().colorscheme
    or 'default')
end
