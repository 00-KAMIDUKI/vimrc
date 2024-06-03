local last_imput_method_name = vim.fn.system("fcitx5-remote -n")

return {
  enter_insert = function()
    vim.fn.system("fcitx5-remote -s " .. last_imput_method_name)
  end,
  leave_insert = function()
    last_imput_method_name = vim.fn.system("fcitx5-remote -n")
    vim.fn.system("fcitx5-remote -c")
  end,
}
