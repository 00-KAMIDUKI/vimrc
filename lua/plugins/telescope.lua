return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ["<C-Down>"] = require('telescope.actions').cycle_history_next,
            ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        }
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown {} },
      }
    }

    -- HACK: Disable warning message (Telescope colorscheme)
    ---@diagnostic disable-next-line: duplicate-set-field
    require 'telescope.utils'.__warn_no_selection = function() end

    telescope.load_extension('ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>ff', builtin.fd, { desc = "Find File" })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Live Grep" })
  end
}
