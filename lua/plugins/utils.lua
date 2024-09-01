return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { "<leader>/", "<cmd>CommentToggle<cr>", desc = "Comment Current Line" },
      { "/",         "<cmd>CommentToggle<cr>", desc = "Comment Toggle",      mode = 'v' },
    },
    config = function(_, opts)
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      local api = require 'Comment.api'

      vim.keymap.set('v', '/', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = 'Comment' })
      require('Comment').setup(opts)
    end,
    opts = {
      toggler = {
        line = '<leader>/'
      },
      post_hook = function(ctx)
        if ctx.cmotion == require('Comment.utils').cmotion.line then
          local rows = ctx.range.erow - ctx.range.srow + 1
          vim.api.nvim_feedkeys(rows .. 'j', 'n', false)
        end
      end,
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    event = "User FileOpened",
    dependencies = {
      'kevinhwang91/promise-async',
    },
    main = 'ufo',
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        if buftype == 'nofile' then return '' end
        return nil
      end,
    },
  },
  {
    'folke/todo-comments.nvim',
    event = "User FileOpened",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      'DiffviewLog',
      'DiffviewOpen',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewToggleFiles',
    },
    config = true
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      keymaps = {
        visual = 's',
        visual_line = 'S',
      },
    },
    config = true,
  },
  {
    'akinsho/toggleterm.nvim',
    keys = {
      { "<leader>\\", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
    opts = {
      open_mapping = '<leader>\\',
      on_open = function()
        vim.wo.spell = false
      end,
      insert_mappings = false,
      shade_terminals = false,
      autochdir = true,
      float_opts = {
        border = 'curved',
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
  },
  -- {
  --   'famiu/bufdelete.nvim',
  --   lazy = true,
  -- },
  -- {
  --   "soulis-1256/eagle.nvim",
  --   config = function()
  --     require('utils.defer').add(function()
  --       require('eagle').setup()
  --     end)
  --   end
  -- },
  -- BUG: this plugin fucks up ModeChanged event of visual mode?
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      win = {
        no_overlap = false,
      },
      spec = {
        { "<leader>f", group = 'Find' },
        { "<leader>c", group = 'Color Picker', icon = { icon = ' ', color = 'Include' } },
        { "<leader>d", group = 'Debug', mode = 'nv' },
        { "<leader>a", icon = { icon = "󰕮 ", hl = 'Operator' } },
        { "<leader>/", icon = { icon = " ", hl = 'String' } },
        { "<space>r", group = 'Refactor', mode = 'nv', icon = { icon = '󰛨', hl = 'WarningMsg' } },
      },
      icons = {
        rules = {
          { pattern = 'debug', icon = ' ', color = 'red' },
          { pattern = 'next', icon = '󰙡 ', color = 'azure' },
          { pattern = 'prev', icon = '󰙣 ', color = 'azure' },
          { pattern = 'terminal', icon = ' ', color = 'red' },
          { pattern = 'left', icon = ' ', color = 'azure' },
          { pattern = 'right', icon = ' ', color = 'azure' },
          { pattern = 'up', icon = ' ', color = 'azure' },
          { pattern = 'down', icon = ' ', color = 'azure' },
        },
      },
    },
  },
  {
    -- TODO: add callback on clicking the virtual text
    'brenoprata10/nvim-highlight-colors',
    event = 'User FileOpened',
    opts = {
      render = 'virtual',
      virtual_symbol = '■',
      virtual_symbol_prefix = ' ',
      virtual_symbol_suffix = '',
      virtual_symbol_position = 'eow',
      ---Highlight hex colors, e.g. '#FFFFFF'
      enable_hex = true,
      ---Highlight short hex colors e.g. '#fff'
      enable_short_hex = true,
      ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
      enable_rgb = true,
      ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
      enable_hsl = true,
      ---Highlight CSS variables, e.g. 'var(--testing-color)'
      enable_var_usage = true,
      ---Highlight named colors, e.g. 'green'
      enable_named_colors = false,
      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = false,
      exclude_filetypes = {},
      exclude_buftypes = {}
    },
    main = 'nvim-highlight-colors',
    config = function(plugin, opts)
      require(plugin.main).setup(opts)
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = require(plugin.main).turnOn
      })
    end
  },
  -- {
  --   'NvChad/nvim-colorizer.lua',
  --   config = true,
  --   opts = {
  --     user_default_options = {
  --       RRGGBBAA = true,
  --       names = false,
  --       css = true,
  --       mode = 'virtualtext',
  --       sass = { enabled = true },
  --     },
  --   },
  -- },
  {
    'uga-rosa/ccc.nvim',
    config = true,
    keys = {
      { '<leader>cp', '<cmd>CccPick<CR>',    desc = 'Pick color' },
      { '<leader>cc', '<cmd>CccConvert<CR>', desc = 'Convert color' },
    },
  },
  {
    'stevearc/stickybuf.nvim',
    opts = {
      get_auto_pin = function(bufnr)
        return vim.tbl_contains({
          'toggleterm',
        }, vim.bo[bufnr].filetype)
      end
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    config = function() require('telescope').load_extension 'refactoring' end,
    keys = {
      {
        '<space>rr',
        function() require 'telescope'.extensions.refactoring.refactors() end,
        mode = { 'n', 'x' },
        desc = "Refactors",
      },
      {
        '<leader>dp',
        function() require('refactoring').debug.printf { below = false } end,
        mode = { 'n' },
        desc = "Print Debug",
      },
      {
        '<leader>dv',
        function() require('refactoring').debug.print_var {} end,
        mode = { 'x', 'n' },
        desc = "Print var",
      },
      {
        '<leader>dc',
        function() require('refactoring').debug.cleanup {} end,
        mode = { 'n' },
        desc = "Cleanup",
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = { "o" },           function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  }
}
