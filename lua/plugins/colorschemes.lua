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

---@alias plugin { [1]: string, name: string, opts: (fun(): table), variants: string[] }

---@type plugin[]
local plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
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
    name = "nightfox",
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
}

local function update_active_plugin(plugin)
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

---@type table<string, fun()>
local setup_functions = {}
for _, plugin in pairs(plugins) do
  plugin.event = "VeryLazy"
  for _, variant in pairs(plugin.variants) do
    setup_functions[variant] = function()
      require(plugin.name).setup(plugin.opts())
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
