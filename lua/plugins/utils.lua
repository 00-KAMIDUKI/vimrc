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
      local api = require('Comment.api')

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
    dependencies = {
      'kevinhwang91/promise-async'
    },
    main = 'ufo',
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        if buftype == 'nofile' then return '' end
        return nil
      end
    }
  },
  {
    'folke/todo-comments.nvim', -- TODO: make this work with nvim-scrollbar
    config = true,
  },
  {
    "sindrets/diffview.nvim",
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
      insert_mappings = false,
      shade_terminals = false,
      -- direction = vim.g.neovide and 'float' or 'horizontal',
      autochdir = true,
      float_opts = {
        border = 'curved',
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      highlights = {
        ["Normal"] = { guibg = 'None' },
      },
    },
  },
  {
    'famiu/bufdelete.nvim',
    lazy = true,
  },
  {
    "soulis-1256/eagle.nvim",
    config = function()
      require('utils.defer').add(function()
        require('eagle').setup()
      end)
    end
  },
  {
    'brenoprata10/nvim-highlight-colors',
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
    config = function() require('telescope').load_extension('refactoring') end,
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
        function() require('refactoring').debug.print_var() end,
        mode = { 'x', 'n' },
        desc = "Print var",
      },
      {
        '<leader>dc',
        function() require('refactoring').debug.cleanup {} end,
        mode = { 'n' },
        desc = "Cleanup",
      },
    }
  },
}
