return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require 'telescope'

    telescope.setup {
      pickers = {
        colorscheme = {
          enable_preview = true,
        }
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown {} },
      }
    }

    telescope.load_extension('ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', 'ff', builtin.fd, { desc = "Find File" })
    vim.keymap.set('n', 'fw', builtin.live_grep, { desc = "Live Grep" })
  end
}
