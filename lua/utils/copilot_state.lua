local client = require 'copilot.client'
local api = require 'copilot.api'

return function()
  if client.is_disabled()
      or not client.buf_is_attached(vim.api.nvim_get_current_buf())
  then
    return 'Disabled'
  end
  return api.status.data.status
end

