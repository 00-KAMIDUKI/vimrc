return {
  -- require 'plugins.ui.lualine',
  require 'plugins.ui.heirline',
  -- require 'plugins.ui.feline',
  require 'plugins.ui.cokeline',
  require 'plugins.ui.statuscol',
  require 'plugins.ui.alpha',
  -- {
  --   'echasnovski/mini.icons',
  --   config = function (_, opts)
  --     require('mini.icons').setup(opts)
  --     MiniIcons.mock_nvim_web_devicons()
  --   end,
  --   opts = {
  --     style = 'ascii',
  --   },
  -- },
  -- TODO: replace this with mini.icons because
  -- the way to configure it is confusing
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    opts = {
      override = {
        yuck = {
          icon = "",
          color = "#b49a49",
          cterm_color = "66",
          name = "Yuck",
        },
        ['.gitignore'] = {
          icon = "",
          color = "#e84b39",
          name = "GitIgnore",
        },
        vim = {
          icon = '',
          color = '#38C765',
          name = 'Vim',
        },
      },
      default = true,
    },
  },
  {
    'nvimdev/indentmini.nvim',
    event = 'User FileOpened',
    opts = {
      char = '▏',
    },
    main = 'indentmini',
    config = function(spec, opts)
      require(spec.main).setup(opts)

      local function set_hl()
        vim.api.nvim_set_hl(0, 'IndentLine', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'IndentLineCurHide', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'IndentLineCurrent', { link = 'Function' })
      end

      set_hl()
      vim.api.nvim_create_autocmd('Colorscheme', {
        callback = set_hl,
        desc = 'Set IndentLine highlights',
      })
    end,
  },
  -- {
  --   'RRethy/vim-illuminate',
  --   config = function()
  --     require 'illuminate'.configure {
  --       filetypes_denylist = {},
  --     }
  --   end,
  -- },
  {
    'petertriho/nvim-scrollbar',
    event = 'User FileOpened',
    opts = {
      handlers = {
        gitsigns = true,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    opts = {},
  },
  {
    'Bekaboo/dropbar.nvim',
    event = 'User FileOpened',
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = 'Neotree',
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Neotree Toggle' },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      open_files_do_not_replace_types = {
        "toggleterm",
        "noice",
        "trouble",
      },
      default_component_configs = {
        modified = {
          symbol = "󰤌",
        },
        symlink_target = {
          enabled = true,
        },
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
        use_libuv_file_watcher = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    event = 'VeryLazy',
    opts = {
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
      cmdline = {
        view = 'cmdline_popup',
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
            find = "No lines", -- No lines in buffer
          },
        },
        {
          filter = {
            event = 'notify',
            kind = 'info',
            find = 'tree INFO', -- fuck neotree
          },
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
    lazy = true,
    opts = {
      render = 'wrapped-compact',
      timeout = 1000,
      background_colour = "#000000",
    },
  },
  -- {
  --   'dgagn/diagflow.nvim',
  --   config = true,
  -- },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      "folke/twilight.nvim",
    },
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
      end,
      on_close = function()
        if vim.g.neovide then
          vim.g.neovide_transparency = vim.g.old_transparency
        end
        vim.cmd 'ScrollbarToggle'
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
