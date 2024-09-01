---@param server_name string
return function(server_name, opts)
  opts = opts or {}
  local update_capability = opts.update_capabilities
  -- opts = require 'coq'.lsp_ensure_capabilities(opts)
  opts.capabilities = require 'cmp_nvim_lsp'.default_capabilities(opts.capabilities)
  if update_capability and opts.capabilities then
    update_capability(opts.capabilities)
  end
  require('lspconfig')[server_name].setup(opts)
end
