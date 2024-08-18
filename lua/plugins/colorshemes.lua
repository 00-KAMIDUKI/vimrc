local colorsheme_variants = {
  catppuccin = "catppuccin",
  nightfox = "nordfox",
}

local activated = colorsheme_variants.catppuccin
local transparent_background = require 'utils.transparent_background'

local plugins = {
  [colorsheme_variants.catppuccin] = {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      show_end_of_buffer = true,
      transparent_background = transparent_background,
      term_colors = true,
      integrations = {
        notify = true,
        dropbar = {
          enabled = true,
          color_mode = true,
        },
        mason = true,
        which_key = true,
        -- neotree = false,
      }
    },
  },
  [colorsheme_variants.nightfox] = {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = transparent_background,
      },
    },
  },
}

for name, plugin in pairs(plugins) do
  if name == activated then
    plugin.priority = 1000
    local old_init = plugin.init
    plugin.init = function(arg)
      if old_init then
        old_init(arg)
      end
      vim.cmd.colorscheme(name)
    end
  end
end

return vim.tbl_values(plugins)

