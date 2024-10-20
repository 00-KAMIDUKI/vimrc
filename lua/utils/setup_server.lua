-- local cmp_nvim_lsp = require 'cmp_nvim_lsp'
-- local default_capability = cmp_nvim_lsp.default_capabilities

local default_capability = require 'utils.init'.id

---@param server_name string
return function(server_name, opts)
  opts = opts or {}
  local update_capability = opts.update_capabilities
  opts.capabilities = default_capability(opts.capabilities)
  if update_capability and opts.capabilities then
    update_capability(opts.capabilities)
  end
  require('lspconfig')[server_name].setup(opts)
end
