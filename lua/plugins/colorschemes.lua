local storage = require 'utils.storage'
local activated = storage.data().colorscheme

local transparent_bg = function()
  return require('utils.transparent').value()
end

local function create_autocmd()
  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = "Persist colorscheme",
    callback = function(args)
      storage.data().colorscheme = args.match
      storage.persist()
    end,
  })
end

local colorscheme_set = pcall(vim.cmd.colorscheme, activated)
if colorscheme_set then create_autocmd() end

---@class plugin
---@field [1] string
---@field main string
---@field opts fun(): table
---@field variants string[]
---@field lazy? boolean
---@field priority? number
---@field init? fun(...)

---@type plugin[]
local plugins = {
  {
    "catppuccin/nvim",
    name = 'catppuccin',
    main = "catppuccin",
    opts = function()
      return {
        show_end_of_buffer = true,
        transparent_background = transparent_bg(),
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
      }
    end,
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
    main = "nightfox",
    opts = function()
      return {
        options = {
          transparent = transparent_bg(),
        },
      }
    end,
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
  {
    "folke/tokyonight.nvim",
    main = 'tokyonight',
    opts = function()
      local transparent = transparent_bg()
      return {
        transparent = transparent,
        styles = {
          sidebars = transparent and 'transparent' or 'dark',
          floats = transparent and 'transparent' or 'dark',
        },
      }
    end,
    variants = {
      'tokyonight',
      'tokyonight-night',
      'tokyonight-storm',
      'tokyonight-day',
      'tokyonight-moon',
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    main = "rose-pine",
    opts = function()
      return {
        styles = {
          transparency = transparent_bg(),
        }
      }
    end,
    variants = {
      "rose-pine",
      "rose-pine-main",
      "rose-pine-moon",
      "rose-pine-dawn",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    main = "kanagawa",
    opts = function()
      return {
        transparent = transparent_bg(),
      }
    end,
    variants = {
      "kanagawa",
      "kanagawa-wave",
      "kanagawa-dragon",
      "kanagawa-lotus",
    }
  },
}

---@param plugin plugin
local function update_active_plugin(plugin)
  plugin.priority = 1000
  local old_init = plugin.init
  plugin.init = function(...)
    if old_init then old_init(...) end
    if not colorscheme_set then
      vim.cmd.colorscheme(activated)
      create_autocmd()
    end
  end
end

---@type table<string, fun()>
local setup_functions = {}
for _, plugin in pairs(plugins) do
  plugin.lazy = true
  for _, variant in pairs(plugin.variants) do
    setup_functions[variant] = function()
      require(plugin.main).setup(plugin.opts())
    end
  end

  if vim.tbl_contains(plugin.variants, activated) then
    update_active_plugin(plugin)
  end
end

vim.api.nvim_create_autocmd('ColorSchemePre', {
  callback = function(args)
    local load = setup_functions[args.match]
    if load then load() end
  end,
  desc = 'reload plugin before change colorscheme',
})

return plugins
