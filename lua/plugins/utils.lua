return {
  {
    'windwp/nvim-autopairs',
    config = true,
  },
  {
    'numToStr/Comment.nvim',
    init = function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      local api = require('Comment.api')

      vim.keymap.set('v', '<leader>/', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = 'Comment' })
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
    'NvChad/nvim-colorizer.lua',
    config = true,
    opts = {
      user_default_options = {
        RRGGBBAA = true,
        css = true,
        mode = 'virtualtext',
        sass = { enabled = true },
      },
    },
  },
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
    opts = {},
    init = function() require('telescope').load_extension('refactoring') end,
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
