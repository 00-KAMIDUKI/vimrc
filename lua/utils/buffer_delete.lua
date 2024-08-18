return function()
  local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
  local modified = vim.api.nvim_get_option_value("modified", {})
  if file_exists == 0 and modified then
    local user_choice = vim.fn.input("The file is not saved, whether to force delete? Press enter or input [y/n]:")
    if user_choice == "y" or string.len(user_choice) == 0 then
      vim.cmd("bd!")
    end
    return
  end
  local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"
  vim.cmd(force and "bd!" or string.format("bp | bd! %s", vim.api.nvim_get_current_buf()))
end
