return function()
  vim.opt_local.hlsearch = false
  vim.api.nvim_command 'normal! :'
end
