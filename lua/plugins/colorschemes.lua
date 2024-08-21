local activated = require 'utils.storage'.data().colorscheme
local transparent_background = require 'utils.transparent_background'

local function create_autocmd()
  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = "Persist colorscheme",
    callback = function(args)
      local storage = require 'utils.storage'
      storage.data().colorscheme = args.match
      storage.persist()
    end,
  })
end

local colorscheme_set = pcall(vim.cmd.colorscheme, activated)
if colorscheme_set then create_autocmd() end

local plugins = {
  {
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
    variants = {
      'catppuccin',
      'catppuccin-latte',
      'catppuccin-mocha',
      'catppuccin-frappe',
      'catppuccin-macchiato',
    },
  },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = transparent_background,
      },
    },
    variants = {
      'nightfox',
      'dayfox',
      'carbonfox',
      'terafox',
      'nordfox',
      'dawnfox',
      'duskfox',
    },
  },
}

local function update_active_plugin(plugin)
  if not plugin then return end
  plugin.priority = 1000
  local old_init = plugin.init
  plugin.init = function(arg)
    if old_init then old_init(arg) end
    if not colorscheme_set then
      vim.cmd.colorscheme(activated)
      create_autocmd()
    end
  end
end

update_active_plugin(require 'utils.tbl_find'(plugins, function(plugin)
  return vim.tbl_contains(plugin.variants, activated)
end))

return plugins
