---@alias Diagnostics { errors: number, warnings: number, infos: number, hints: number }

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
  return diagnostics.errors
      + diagnostics.warnings
      + diagnostics.infos
      + diagnostics.hints
end

local diagnostic_hl = {
  'DiagnosticError',
  'DiagnosticWarn',
  'DiagnosticInfo',
  'DiagnosticHint',
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
  text = function(buffer) return buffer.devicon.icon end,
  fg = function(buffer) return buffer.devicon.color end,
}

local prefix = {
  text = function(buffer) return buffer.unique_prefix end,
  fg = 'Comment',
  underline = function(buffer) return buffer.is_hovered end,
  italic = true,
}

local filename = {
  text = function(buffer) return buffer.filename end,
  bold = function(buffer) return buffer.is_focused end,
  underline = function(buffer) return buffer.is_hovered end,
  fg = function(buffer)
    return diagnostic_hl[diagnostic_severity(buffer.diagnostics)]
  end,
}

local diag_count = {
  text = function(buffer)
    local count = diagnostic_count(buffer.diagnostics)
    return count > 0 and count or ""
  end,
  fg = function(buffer)
    return diagnostic_hl[diagnostic_severity(buffer.diagnostics)]
  end,
}

local close_icon = {
  text = function(buffer)
    if buffer.is_modified then return "" end
    if buffer.is_hovered then return "󰅙" end
    return "󰅖"
  end,
  on_click = function(_, _, _, _, buffer) buffer:delete() end,
}

local default_hl = function(buffer)
  return buffer.is_focused and 'Visual' or 'CursorLine'
end

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
      { text = '  ', bg = 'Normal', fg = 'Normal' },
      { text = '  ', bg = 'Normal', fg = 'Normal' },
      { text = '  ', bg = 'Normal', fg = 'Normal' },
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
        { text = '', },
      },
    },
    components = {
      head,
      padding,
      icon,
      prefix,
      filename,
      padding,
      diag_count,
      padding,
      close_icon,
      padding,
    },
    default_hl = {
      fg = default_hl,
      bg = default_hl,
    },
    fill_hl = 'Normal',
  },
}
