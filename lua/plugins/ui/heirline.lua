return {
  "rebelot/heirline.nvim",
  event = "User FileOpened",
  config = function()
    local utils = require "heirline.utils"

    local color_cache = {}

    local function default_fg()
      if color_cache.default_fg == nil then
        color_cache.default_fg = require 'utils.transparent'.value
            and utils.get_highlight('Normal').fg
            or utils.get_highlight('CursorLine').fg
      end
      return color_cache.default_fg
    end

    local function default_bg()
      if color_cache.default_bg == nil then
        color_cache.default_bg = require 'utils.transparent'.value
            and 'NONE'
            or utils.get_highlight('CursorLine').bg
      end
      return color_cache.default_bg
    end

    local remote = {
      provider = '  ',
      hl = function()
        return {
          fg = default_bg() ~= 'NONE' and default_bg() or '#121318',
          bg = utils.get_highlight(({
            n = 'function',
            i = 'string',
            v = 'keyword',
            V = 'include',
            t = 'label',
            c = 'constant',
            R = '@variable.builtin',
            [''] = '@variable.parameter'
          })[vim.fn.mode()] or 'DevIconBazel').fg
        }
      end,
      update = "ModeChanged",
    }

    local git_directory = nil
    local function update_git_directory()
      git_directory = vim.fn.getcwd()
      while git_directory do
        if io.open(git_directory .. '/.git', 'r') then return end
        git_directory = string.match(git_directory, '^(.+)/')
      end
    end

    --- @return boolean
    local function is_git_directory()
      update_git_directory()
      return git_directory ~= nil
    end

    --- @return string
    local function git_branch()
      if not git_directory then return "" end
      local f = io.open(('%s/.git/HEAD'):format(git_directory), 'r')
      return f and string.match(f:read(), '([^/]*)$'):sub(1, 6) or ""
    end

    local branch = {
      condition = is_git_directory,
      { provider = " 󰘬 " },
      { provider = git_branch },
      update = 'DirChanged',
    }

    local diagnostics = {
      condition = function()
        return vim.bo.filetype == 'Trouble' or #vim.lsp.get_clients { bufnr = 0 } > 0
      end,
      {
        provider = function() return '  ' .. (vim.diagnostic.count(0)[1] or 0) end,
        hl = function()
          return {
            fg = vim.diagnostic.count(0)[1] and utils.get_highlight 'DiagnosticError'.fg or default_fg(),
            bg = default_bg(),
          }
        end,
      },
      {
        provider = function() return '  ' .. (vim.diagnostic.count(0)[2] or 0) end,
        hl = function()
          return {
            fg = vim.diagnostic.count(0)[2] and utils.get_highlight 'DiagnosticWarn'.fg or default_fg(),
            bg = default_bg(),
          }
        end,
      },
      on_click = {
        callback = function()
          require 'trouble'.toggle 'diagnostics'
        end,
        name = "toggle_trouble_diag",
      },
      update = 'DiagnosticChanged',
    }

    local align = { provider = "%=" }
    local truncate = { provider = "%<" }

    ---@param x number
    ---@return boolean
    local not_nil_and_gt_0 = function(x)
      return x and x > 0
    end

    local send_event = function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'PaperLineUpdateDiff',
      })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitSignsUpdate',
      callback = send_event,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = send_event,
    })

    local diff = {
      condition = function() return vim.b.gitsigns_status_dict end,
      update = {
        "User",
        pattern = 'PaperLineUpdateDiff',
      },
      {
        provider = function() return ' ' .. vim.b.gitsigns_status_dict.added .. ' ' end,
        condition = function() return not_nil_and_gt_0(vim.b.gitsigns_status_dict.added) end,
        hl = 'DiagnosticSignOk'
      },
      {
        provider = function() return ' ' .. vim.b.gitsigns_status_dict.changed .. ' ' end,
        condition = function() return not_nil_and_gt_0(vim.b.gitsigns_status_dict.changed) end,
        hl = 'DiagnosticSignWarn'
      },
      {
        provider = function() return ' ' .. vim.b.gitsigns_status_dict.removed .. ' ' end,
        condition = function() return not_nil_and_gt_0(vim.b.gitsigns_status_dict.removed) end,
        hl = 'DiagnosticSignError'
      },
    }

    local selected = {
      provider = function()
        local starts = vim.fn.line('v')
        local ends = vim.fn.line('.')
        local lines = (starts <= ends and ends - starts or starts - ends) + 1
        return ' ' .. lines .. ' '
      end,
      condition = function() return vim.fn.mode():find('[Vv]') end,
      hl = function() return { fg = utils.get_highlight('@type').fg, bg = default_bg() } end,
      update = { 'CursorMoved', 'ModeChanged' },
    }

    local filetype_icon_lut = {
      help                = { icon = ' ', fg = '#def023' },
      ['neo-tree']        = { icon = '󰙅 ', fg = '#E8C972' },
      toggleterm          = { icon = ' ', fg = '#6A7580' },
      ['TelescopePrompt'] = { icon = ' ', fg = '#c9409e' },
      trouble             = { icon = ' ', fg = '#1dc3d8' },
      lazy                = { icon = '󰒲 ', fg = '#00ffff' },
    }

    local filetype = {
      static = {
        text = nil,
        fg = nil,
      },
      ---@param self { text: string, fg: string }
      init = function(self)
        if vim.bo.buftype == '' then
          local filename = vim.fn.expand '%:t'
          local icon, fg = require 'nvim-web-devicons'.get_icon_color(filename, nil, {
            default = false,
          })
          if icon then
            self.text = icon .. ' '
            self.fg = fg
            return
          end
        end

        local ft = vim.bo.filetype
        local icon, fg = require 'nvim-web-devicons'.get_icon_color_by_filetype(ft, {
          default = false,
        })
        if icon then
          self.text = icon .. ' '
          self.fg = fg
          return
        end

        local entry = filetype_icon_lut[ft]
        if entry then
          self.text = entry.icon
          self.fg = entry.fg
        else
          self.text = ft .. ' '
          self.fg = default_fg()
        end
      end,
      provider = function(self) return self.text end,
      hl = function(self)
        return {
          fg = self.fg,
          bg = default_bg(),
        }
      end,
      update = "BufEnter",
    }

    local position = {
      provider = function() return '%p%%%L %l:%c' end,
      condition = function()
        return vim.o.buftype == ''
      end,
      update = "BufEnter",
    }
    local copilot = {}
    local notification = {
      provider = '  ',
    }

    local disable_for_file_types = {
      'alpha'
    }

    local enabled = {
      hl = function()
        return {
          fg = default_fg(),
          bg = default_bg(),
        }
      end,
      condition = function()
        return not vim.tbl_contains(disable_for_file_types, vim.bo.filetype)
      end,
      remote,
      truncate,
      branch,
      diagnostics,
      align,
      selected,
      diff,
      filetype,
      position,
      copilot,
      notification,
    }

    local disabled = {
      hl = {
        bg = 'NONE',
      },
      condition = function()
        return vim.tbl_contains(disable_for_file_types, vim.bo.filetype)
      end,
      update = "BufEnter",
      align,
    }

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        color_cache = {}
        utils.on_colorscheme()
      end,
    })

    require 'heirline'.setup {
      statusline = {
        disabled,
        enabled,
      },
    }
  end,
}
