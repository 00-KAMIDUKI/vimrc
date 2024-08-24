return {
  'goolord/alpha-nvim',
  cmd = 'Alpha',
  event = 'User Dashboard',
  init = function()
    if vim.fn.argc() > 0 then return end
    vim.api.nvim_exec_autocmds("User", {
      pattern = 'Dashboard',
    })
  end,
  keys = {
    { '<leader>a', '<cmd>Alpha<CR>', { desc = 'Dashboard' } },
  },
  config = function()
    vim.o.statusline='%#Normal#'

    local dashboard = require 'alpha.themes.dashboard'
    local header = require 'utils.header'

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = header.anim_start,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaClosed',
      callback = header.anim_stop,
    })

    local highlights = {
      version = 'HeaderNvimVersion',
      package = 'HeaderPackages',
      git_hub = 'HeaderGitHub',
    }
    local function setup_hl()
      vim.api.nvim_set_hl(0, highlights.version, { fg = '#98c09d' })
      vim.api.nvim_set_hl(0, highlights.package, { fg = '#c7b48a' })
      vim.api.nvim_set_hl(0, highlights.git_hub, { fg = '#b094bf' })
    end

    setup_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = setup_hl,
    })

    dashboard.section.buttons.val = {
      dashboard.button('a', '   new file', vim.cmd.bd),
      dashboard.button('w', '󰺄   find word', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('o', '   old files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('r', '   restore', require('utils.session').load_last_session),
      dashboard.button('s', '   sessions', require('utils.session').select_project),
      dashboard.button('c', '   configure', function() vim.cmd.edit(vim.fn.stdpath('config')) end),
      dashboard.button('q', '   quit', vim.cmd.quit),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'Function'
    end

    local version = vim.version()
    version = (" %d.%d.%d"):format(version.major, version.minor, version.patch)

    local package_info = '󰏖 ' .. require('lazy').stats().loaded .. ' loaded'
    dashboard.section.buttons.opts.spacing = 1

    local info = {
      type = "text",
      val = version .. '    ' .. package_info .. '    lunedepapier',
      opts = {
        position = "center",
        hl = {
          { highlights.version, 0,                            #version },
          { highlights.package, #version,                     #version + #package_info + 4 },
          { highlights.git_hub, #version + #package_info + 4, -1 },
        },
      }
    }

    local icons = {
      "",
      "󱢇",
      "",
      "",
      "󰲒",
      "󰣚",
      "󰼁",
      "󱃽",
      "󰗃",
      "",
      "",
      "",
      "󰣇",
      "󰚄",
      "󱢴",
      "󱐂",
      "󱣼",
      "󰩈",
      "󱐋",
      "󰍳",
      "󰼾",
      "",
    }
    local fortune = require 'alpha.fortune'
    dashboard.section.footer.val = fortune {
      max_width = 60,
    }

    table.remove(dashboard.section.footer.val, 1)
    dashboard.section.footer.val[1] = icons[math.random(#icons)] .. ' ' .. dashboard.section.footer.val[1]

    dashboard.opts.layout = {
      { type = "group",   val = header.content },
      info,
      { type = 'padding', val = 1, },
      dashboard.section.buttons,
      dashboard.section.footer,
    }

    require 'alpha'.setup(dashboard.opts)
  end,
}
