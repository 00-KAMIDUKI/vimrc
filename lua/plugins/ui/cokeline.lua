---@alias Diagnostics {errors: number, warnings: number, infos: number, hints: number}

---@param diagnostics Diagnostics
---@return number
local function diagnostic_severity(diagnostics)
  if diagnostics.errors > 0 then
    return 1
  elseif diagnostics.warnings > 0 then
    return 2
  elseif diagnostics.infos > 0 then
    return 3
  elseif diagnostics.hints > 0 then
    return 4
  else
    return 0
  end
end

---@param diagnostics Diagnostics
---@return number
local function diagnostic_count(diagnostics)
  return diagnostics.errors + diagnostics.warnings + diagnostics.infos + diagnostics.hints
end

local diagnostic_hl = {
  'LspDiagnosticsError',
  'LspDiagnosticsWarning',
  'LspDiagnosticsInformation',
  'LspDiagnosticsHint',
}

-- local diagnostic_signs = {
--   '󰅚', -- Error
--   '', -- Warning
--   '󰋽', -- Info
--   '󰌶', -- Hint
-- }

local padding = {
  text = " ",
}

local head = {
  text = function(buffer) return buffer.is_focused and '▍' or ' ' end,
  fg = 'TabLineSel',
}

local icon = {
  text = function(buffer)
    return require 'nvim-web-devicons'.get_icon(buffer.filename)
  end,
  fg = function(buffer)
    local _, hl = require 'nvim-web-devicons'.get_icon(buffer.filename)
    return hl
  end,
}

local prefix = {
  text = function(buffer)
    return buffer.unique_prefix
  end,
  fg = function()
    return require('cokeline.hlgroups').get_hl_attr("Comment", "fg")
  end,
  italic = true,
}

local filename = {
  text = function(buffer)
    return buffer.filename
  end,
  bold = function(buffer) return buffer.is_focused end,
  fg = function(buffer)
    local severity = diagnostic_severity(buffer.diagnostics)
    return diagnostic_hl[severity]
  end,
}

local diag_count = {
  text = function(buffer)
    local count = diagnostic_count(buffer.diagnostics)
    if count > 0 then
      return count
    end
    return ""
  end,
  fg = function(buffer)
    local severity = diagnostic_severity(buffer.diagnostics)
    return diagnostic_hl[severity]
  end,
}

local close_icon = {
  text = function(buffer)
    if buffer.is_modified then
      return ""
    end
    if buffer.is_hovered then
      return "󰅙"
    end
    return "󰅖"
  end,
  on_click = function(_, _, _, _, buffer)
    buffer:delete()
  end,
}

return {
  'willothy/nvim-cokeline',
  config = true,
  opts = {
    buffers = {
      filter_valid = function(buffer)
        return not buffer.type ~= 'terminal'
      end,
    },
    rhs = {
      {
        text = '  ',
        bg = 'NONE',
        fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg,
      },
      {
        text = '  ',
        bg = 'NONE',
        fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg,
      },
      {
        text = '  ',
        bg = 'NONE',
        fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg,
      },
    },
    sidebar = {
      filetype = { 'neo-tree' },
      components = {
        {
          text = function(buf)
            local winid = vim.fn.bufwinid(buf.number)
            local win_width = vim.fn.winwidth(winid)
            local label = ' EXPLORER'
            return label .. (' '):rep(win_width - #label - 2)
          end
        },
        {
          text = '',
        },
      },
    },
    components = {
      head,
      padding,
      icon,
      padding,
      prefix,
      filename,
      padding,
      diag_count,
      padding,
      close_icon,
      padding,
    },
    default_hl = {
      fg = 'NONE',
      bg = function(buffer)
        return buffer.is_focused and "TabLineSel" or "TabLine"
      end,
    },
  },
}
