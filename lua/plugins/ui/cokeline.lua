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

local tabline_bg = require 'utils.transparent'.statusline_hl.bg
local tabline_fg = require 'utils.transparent'.statusline_hl.fg

local tabline_selected_bg = "TabLineSel"
local tabline_selected_fg = tabline_selected_bg

local padding = {
  text = " ",
}

local head = {
  text = function(buffer) return buffer.is_focused and '▍' or buffer.index == 1 and ' ' or '' end,
  fg = function(buffer) return buffer.is_focused
    and vim.api.nvim_get_hl(0, { name = 'ModeColor', link = false }).fg
    or tabline_fg() end
}

local function is_picking_focus()
  return require 'cokeline.mappings'.is_picking_focus()
end

local function is_picking_close()
  return require 'cokeline.mappings'.is_picking_close()
end

local icon = {
  text = function(buffer)
    return (is_picking_focus() or is_picking_close())
        and buffer.pick_letter .. ' '
        or buffer.devicon.icon
  end,
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
    return (diagnostic_hl[diagnostic_severity(buffer.diagnostics)] or buffer.is_focused)
      and tabline_selected_fg
      or tabline_fg()
  end,
}

local diag_count = {
  text = function(buffer)
    local count = diagnostic_count(buffer.diagnostics)
    return count > 0 and count .. ' ' or ""
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

return {
  'willothy/nvim-cokeline',
  event = 'User FileOpened',
  main = 'cokeline',
  config = function(plugin, opts)
    vim.g.tabline_plugin_loaded = true
    require(plugin.main).setup(opts)

    vim.keymap.set('n', '<leader>s', function()
      require 'cokeline.mappings'.pick 'focus'
    end, { desc = "Pick a buffer to focus" })
    vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true })
    vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
  end,
  opts = {
    rhs = {
      { text = '  ', highlight = 'TabLineFill' },
      { text = '  ', highlight = 'TabLineFill', on_click = function() vim.cmd.vsplit() end },
      { text = '  ', highlight = 'TabLineFill' },
    },
    sidebar = {
      filetype = { 'neo-tree' },
      components = {
        {
          text = function(buffer)
            local winid = vim.fn.bufwinid(buffer.number)
            local win_width = vim.fn.winwidth(winid)
            local label = ' EXPLORER'
            return label .. (' '):rep(win_width - #label - 2)
          end,
        },
        {
          text = '',
          on_click = function()
            local neo_tree_win = vim.tbl_filter(function(win)
              local buf = vim.api.nvim_win_get_buf(win)
              return vim.api.nvim_get_option_value('filetype', { buf = buf }) == 'neo-tree'
            end, vim.api.nvim_tabpage_list_wins(0))[1]
            if not neo_tree_win then return end
            if vim.api.nvim_get_option_value('winbar', { win = neo_tree_win }) == '' then
              vim.api.nvim_set_option_value('winbar', [[%{%v:lua.require'neo-tree.ui.selector'.get()%}]], {
                win = neo_tree_win,
              })
            else
              vim.api.nvim_set_option_value('winbar', '', {
                win = neo_tree_win,
              })
            end
          end
        },
      },
    },
    components = {
      head,
      icon,
      prefix,
      filename,
      padding,
      diag_count,
      close_icon,
      padding,
    },
    default_hl = {
      fg = function(buffer) return buffer.is_focused and tabline_selected_fg or tabline_fg() end,
      bg = function(buffer) return buffer.is_focused and tabline_selected_bg or tabline_bg() end,
    },
  },
}
