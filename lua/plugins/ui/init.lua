return {
  require 'plugins.ui.lualine',
  require 'plugins.ui.cokeline',
  require 'plugins.ui.statuscol',
  {
    'kyazdani42/nvim-web-devicons',
    opts = {
      override = {
        yuck = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Yuck"
        }
      },
      default = true,
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '▏' },
      scope = { highlight = 'Function', show_start = false, show_end = false },
    },
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      require 'illuminate'.configure {
        filetypes_denylist = {},
      }
      if not vim.g.neovide then
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
      end
    end,
  },
  -- {
  --   'akinsho/bufferline.nvim',
  --   -- cond = not vim.g.neovide,
  --   opts = {
  --     options = {
  --       themable = true,
  --       offsets = {
  --         {
  --           filetype = 'neo-tree',
  --           text = vim.g.neovide and 'EXPLORER                 ' or 'FILE EXPLORER',
  --           text_align = 'center',
  --           seperator = true,
  --         }
  --       },
  --       diagnostics = 'nvim_lsp',
  --       truncate_names = true,
  --       separator_style = 'thin',
  --       diagnostics_indicator = function(count, level)
  --         local icon = level:match("error") and " " or
  --             level:match("warning") and " " or " "
  --         return " " .. icon .. count
  --       end,
  --       close_command = function(bufnum)
  --         require('bufdelete').bufdelete(bufnum, true)
  --       end,
  --     },
  --   },
  -- },
  {
    'petertriho/nvim-scrollbar',
    opts = {
      handlers = {
        gitsigns = true,
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local which_key = require 'which-key'
      which_key.register({
        ['f'] = {
          name = 'Find',
        },
      }, { mode = 'n' })
    end,
    config = true,
  },
  {
    'Bekaboo/dropbar.nvim',
    cond = vim.fn.has('nvim-0.10') == 1,
    config = true,
  },
  {
    'goolord/alpha-nvim',
    config = function()
      vim.keymap.set('n', '<leader>a', '<cmd>Alpha<CR>', { desc = 'Dashboard' })

      local dashboard = require('alpha.themes.dashboard')

      vim.api.nvim_set_hl(0, "HeaderNvimVersion", { fg = '#98c09d' })
      vim.api.nvim_set_hl(0, "HeaderPackages", { fg = '#c7b48a' })
      vim.api.nvim_set_hl(0, "HeaderGithub", { fg = '#b094bf' })

      dashboard.section.buttons.val = {
        dashboard.button('a', '   new file', '<cmd>bd<CR>'),
        dashboard.button('w', '󰺄   find word', '<cmd>Telescope live_grep<CR>'),
        dashboard.button('o', '   old files', '<cmd>Telescope oldfiles<CR>'),
        dashboard.button('r', '   restore', require('utils.session').load_last_session),
        dashboard.button('s', '   sessions', require('utils.session').select_project),
        dashboard.button('c', '   configure', '<cmd>exe "edit " . stdpath("config")<CR>'),
        dashboard.button('q', '   quit', '<cmd>q<CR>'),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'Function'
      end

      local version = vim.version()
      version = (" %d.%d.%d"):format(version.major, version.minor, version.patch)

      local package_info = '󰏖 ' .. require('lazy').stats().loaded .. ' loaded'
      dashboard.section.buttons.opts.spacing = 1

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
      local fortune = require('alpha.fortune')
      dashboard.section.footer.val = fortune({
        max_width = 60,
      })

      table.remove(dashboard.section.footer.val, 1)
      dashboard.section.footer.val[1] = icons[math.random(#icons)] .. ' ' .. dashboard.section.footer.val[1]

      dashboard.opts.layout = {
        { type = "group",   val = require('utils.header') },
        {
          type = "text",
          val = version .. '    ' .. package_info .. '    lunedepapier',
          opts = {
            position = "center",
            hl = { { "HeaderNvimVersion", 0, #version }, { "HeaderPackages", #version, #version + #package_info + 4 }, { "HeaderGithub", #version + #package_info + 4, -1 } },
          }
        },
        { type = 'padding', val = 1, },
        dashboard.section.buttons,
        dashboard.section.footer,
      }

      require 'alpha'.setup(dashboard.opts)
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle File Tree' })
      vim.api.nvim_create_autocmd('BufEnter', {
        -- make a group to be able to delete it later
        group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
        callback = function()
          local f = vim.fn.expand('%:p')
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd('Neotree left dir=' .. f)
            -- neo-tree is loaded now, delete the init autocmd
            vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
          end
        end
      })
    end,
    opts = {
      open_files_do_not_replace_types = {
        "toggleterm",
        "noice",
        "trouble",
      },
      filesystem = {
        window = {
          width = 30,
          mappings = {
            ['<Tab>'] = { 'toggle_preview', config = { use_float = false } },
            ['l'] = 'none',
          },
        },
        follow_current_file = {
          enable = true,
        },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
      cmdline = {
        view = 'cmdline_popup',
      },
      messages = {
        view_search = false,
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'lines --[0-9]*%--',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = '[0-9]*L, [0-9]*B',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = '--No',
          },
          opts = { skip = true },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          silent = true,
        },
        signature = {
          enabled = true,
        },
        documentation = {
          view = 'hover'
        }
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = 'wrapped-compact',
      timeout = 1000,
      background_colour = "#000000",
    },
  },
  {
    'dgagn/diagflow.nvim',
    config = true,
  },
  {
    "folke/twilight.nvim",
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        options = {
          winbar = "",
          foldcolumn = "0",
        },
      },
      plugins = {
        options = {
          laststatus = 0,
        },
        gitsigns = false,
      },
      on_open = function()
        if vim.g.neovide then
          vim.g.old_transparency = vim.g.neovide_transparency
          vim.g.neovide_transparency = 100
        end
        vim.cmd 'ScrollbarToggle'
        -- vim.cmd 'Noice disable'
        vim.cmd 'ColorizerToggle'
      end,
      on_close = function()
        if vim.g.neovide then
          vim.g.neovide_transparency = vim.g.old_transparency
        end
        vim.cmd 'ScrollbarToggle'
        -- vim.cmd 'Noice enable'
        vim.cmd 'ColorizerToggle'
      end,
    },
    keys = {
      { '<leader>z', function() require('zen-mode').toggle() end, desc = 'Zen Mode' },
    },
  },
  -- {
  --   "folke/edgy.nvim",
  --   opts = {
  --     left = {
  --       'neo-tree'
  --     },
  --     bottom = {
  --       'toggleterm'
  --     },
  --     animate = {
  --       enable = false,
  --     },
  --   },
  -- },
  -- {
  --   'tamton-aquib/duck.nvim',
  --   config = true,
  -- },
  -- {
  --   "karb94/neoscroll.nvim",
  --   config = true,
  -- }
}

