local set_diag_signs
if vim.version().minor < 10 then
  set_diag_signs = function(entries)
    for _, entry in pairs(entries) do
      vim.fn.sign_define('DiagnosticSign' .. entry[1], { text = entry[2], texthl = 'DiagnosticSign' .. entry[1] })
    end
  end
else
  set_diag_signs = function(entries)
    local text = {}
    for _, entry in pairs(entries) do
      table.insert(text, entry[2])
    end
    vim.diagnostic.config { signs = { text = text } }
  end
end

return function()
  set_diag_signs {
    { "Error", "" },
    { "Warn", "" },
    { "Info", "" },
    { "Hint", "󰌵" },
  }
end
