local action = function()
  vim.api.nvim_del_augroup_by_name 'FileOpened'
  vim.api.nvim_exec_autocmds("User", { pattern = "FileOpened" })
end
return {
  action = action,
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if (vim.fn.expand "%" ~= "" and buftype ~= "nofile") then
      action()
    end
  end
}
