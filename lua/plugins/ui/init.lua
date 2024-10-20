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
      override_by_filename = {
        ['.gitignore'] = {
          icon = "",
          color = "#e84b39",
          name = "GitIgnore",
        },
        ['.clang-format'] = {
          icon = "",
          color = "#97a965",
          cterm_color = "106",
          name = "Yuck",
        },
      },
      override = {
        yuck = {
          icon = "",
          color = "#b49a49",
          cterm_color = "100",
          name = "Yuck",
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
    config = function(plugin, opts)
      require(plugin.main).setup(opts)

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
    init = function()
      if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv()[1]) ~= 0 then
        require('utils.on_file_opened').action()
        require 'neo-tree'
      end
    end,
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Neotree Toggle' },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    main = "neo-tree",
    config = function(plugin, opts)
      local function set_hl()
        local bg = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal", link = true }).bg
        local active = vim.api.nvim_get_hl(0, { name = "NeoTreeRootName", link = true }).fg
        local inactive = vim.api.nvim_get_hl(0, { name = "Comment", link = true }).fg
        vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { fg = inactive, bg = bg })
        vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { fg = active, bg = bg })
        vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorInactive', { fg = inactive, bg = bg })
        vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorActive', { fg = inactive, bg = bg })
      end
      set_hl()
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = set_hl,
        desc = 'Neotree highlight',
      })
      require(plugin.main).setup(opts)
    end,
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem", display_name = " 󰉕  " },
          { source = "buffers", display_name = " 󰈔  " },
          { source = "git_status", display_name = " 󰊢  " },
          { source = "document_symbols", display_name = "   " },
        },
        padding = { left = 2, right = -1 },
        separator = { left = "󱪼", right = "" },
        content_layout = "center",
        tabs_layout = "equal",
        -- highlight_tab = "Comment",
        -- highlight_tab_active = "ModeColor",
        -- highlight_background = "Comment",
        -- highlight_separator = "Comment",
        -- highlight_separator_active = "Comment",
      },
      close_if_last_window = true,
      open_files_do_not_replace_types = {
        "toggleterm",
        "noice",
        "trouble",
      },
      default_component_configs = {
        icon = {
          provider = function(icon, node, _)
            if node.type == "file" or node.type == "terminal" then
              local web_devicons = require "nvim-web-devicons"
              local name = node.type == "terminal" and "terminal" or node.name
              local text, hl = web_devicons.get_icon(name)
              icon.text = text or icon.text
              icon.highlight = hl or icon.highlight
            elseif node.type == "directory" then
              if node.id == vim.env['HOME'] then
                icon.text = "󱂵"
              elseif node.name:match 'src' or node.name:match 'source' then
                icon.highlight = 'DiagnosticOk'
              elseif node.name:match 'build' or node.name:match 'target' or node.name:match 'dist' then
                icon.highlight = 'DiagnosticWarn'
              elseif node.name == 'node_modules' then
                icon.text = ""
              elseif node.name == '.git' then
                icon.text = ""
              elseif node.name:match 'config' then
                icon.text = ""
              elseif node.name:match 'assets' then
                icon.text = "󰉏"
              end
            end
          end,
        },
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
    -- event = 'VeryLazy', -- BUG: flickers
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = false,
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
            find = 'lines? --[0-9]*%--',
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
        progress = {
          throttle = 20, -- frequency to update lsp progress message
        },
        hover = {
          silent = true,
        },
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
        gitsigns = { enabled = true },
      },
      on_open = function()
        if vim.g.neovide then
          vim.g.old_transparency = vim.g.neovide_transparency
          vim.g.neovide_transparency = 100
        end
        require 'scrollbar.utils'.toggle()
        if io.popen 'hyprctl activewindow':read "*a":match 'fullscreen: 0' then
          vim.g.is_fullscreen = false
          io.popen 'hyprctl dispatch fullscreen'
        else
          vim.g.is_fullscreen = true
        end
      end,
      on_close = function()
        if vim.g.neovide then
          vim.g.neovide_transparency = vim.g.old_transparency
        end
        require 'scrollbar.utils'.toggle()
        if not io.popen 'hyprctl activewindow':read "*a":match 'fullscreen: 0' and not vim.g.is_fullscreen then
          io.popen 'hyprctl dispatch fullscreen'
        end
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
