return function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      desc = "Clear All the References",
    })
  end
end
