-- ---@param flag boolean
-- ---@param a string
-- ---@param b string
-- local function get_flip(flag, a, b)
--   return function()
--     flag = not flag
--     return flag and a or b
--   end
-- end

local function get_spinner(idx)
  local spinner_icons = {
    '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'
  }
  return function()
    idx = (idx + 1) % #spinner_icons
    return spinner_icons[idx + 1]
  end
end

local copilot_state = require('utils.copilot_state')
local function copilot()
  local spinner = get_spinner(0)
  -- local flip = get_flip(true, "", "●")
  return function()
    local state = copilot_state()
    if state == "Normal" then
      return ""
    elseif state == "InProgress" then
      return spinner()
    elseif state == "Warning" then
      return ""
    elseif state == "Disabled" then
      return ""
    else
      return ''
      -- return vim.g.neovide and '' or flip()
    end
  end
end

local hide_in_width = function() return vim.fn.winwidth(0) > 40 end

return {
  'nvim-lualine/lualine.nvim',
  opts = --[[ vim.g.neovide and ]] {
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha' },
        -- tabline = { 'alpha' },
      },
      refresh = {
        statusline = 200,
      },
    },
    sections = {
      lualine_a = {
        { function() return '' end },
      },
      lualine_b = {},
      lualine_c = {
        {
          'branch',
          icon = '󰘬',
          always_visible = true,
        },
        {
          function() return ' ' .. (vim.diagnostic.count(0)[1] or 0) end,
          padding = { left = 1, right = 0 },
          cond = function() return vim.bo.filetype == 'Trouble' or #vim.lsp.get_clients { bufnr = 0 } > 0 end,
          color = function() return vim.diagnostic.count(0)[1] and 'LspDiagnosticsError' or nil end,
          on_click = function() require('trouble').toggle() end,
        },
        {
          function() return ' ' .. (vim.diagnostic.count(0)[2] or 0) end,
          cond = function() return vim.bo.filetype == 'Trouble' or #vim.lsp.get_clients { bufnr = 0 } > 0 end,
          color = function() return vim.diagnostic.count(0)[2] and 'LspDiagnosticsWarning' or nil end,
          on_click = function() require('trouble').toggle() end,
        },
      },
      lualine_x = {
        {
          'diff',
          symbols = { added = " ", modified = " ", removed = " " },
          cond = hide_in_width,
        },
        {
          function()
            return require 'nvim-web-devicons'.get_icon_by_filetype(vim.bo.filetype, {
              default = false
            }) or vim.bo.filetype
          end,
          color = function()
            local _, fg = require 'nvim-web-devicons'.get_icon_color_by_filetype(vim.bo.filetype, { default = false })
            if fg then
              return { fg = fg }
            end
          end,
          padding = { left = 1, right = 0 },
          cond = function() return vim.bo.buftype ~= 'nofile' end,
        },
        {
          '%p%%%L',
          padding = { left = 1, right = 0 },
          cond = function() return vim.bo.buftype ~= 'nofile' end,
        },
        {
          '%l:%c',
          padding = { left = 1, right = 0 },
          cond = function() return vim.bo.buftype ~= 'nofile' end,
        },
        {
          copilot(),
        },
        {
          function() return "" end,
        }
      },
      lualine_y = {},
      lualine_z = {},
    },
  -- } or {
  --   options = {
  --     component_separators = { left = '', right = '' },
  --     section_separators = { left = '', right = '' },
  --     disabled_filetypes = {
  --       statusline = { 'alpha' },
  --     },
  --     refresh = {
  --       statusline = 200,
  --     },
  --   },
  --   sections = {
  --     lualine_a = {
  --       {
  --         copilot(),
  --         separator = { left = '' },
  --         padding = 0,
  --       },
  --       { 'mode', separator = { right = '' } },
  --     },
  --     lualine_b = {
  --       { 'branch' },
  --     },
  --     lualine_c = {
  --       {
  --         'diff',
  --         symbols = { added = " ", modified = " ", removed = " " },
  --       }, 'diagnostics' },
  --     lualine_x = {
  --       {
  --         'filetype',
  --         icon_only = true,
  --         padding = { left = 0, right = 1 },
  --       },
  --     },
  --     lualine_y = {
  --       {
  --         '%p%%%L',
  --         padding = { left = 0, right = 1 },
  --         cond = function() return vim.bo.buftype ~= 'nofile' end,
  --       },
  --     },
  --     lualine_z = {
  --       {
  --         '%l:%c',
  --         separator = { right = '' },
  --         padding = { left = 1, right = 0 },
  --         cond = function() return vim.bo.buftype ~= 'nofile' end,
  --       },
  --     },
  --   },
  --   inactive_sections = {
  --     lualine_c = { { 'filename', padding = 0 } },
  --     lualine_x = { 'location' },
  --   },
  },
}
