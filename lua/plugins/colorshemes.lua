---@diagnostic disable: unused-function, unused-local
local function set_terminal_colors(colors)
  for i, color in pairs(colors) do
    vim.g["terminal_color_" .. i] = color
  end
end

local function shuffle(tbl)
  local n = #tbl
  while n > 2 do
    local k = math.random(n)
    tbl[n], tbl[k] = tbl[k], tbl[n]
    n = n - 1
  end
  return tbl
end

local activated = 1
local transparent_background = not vim.g.neovide

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
        neotree = false,
      }
    },
    -- init = function()
    --   local palette = require("catppuccin.palettes").get_palette 'mocha'
    --   local terminal_colors = {}
    --   for k, color in pairs(palette) do
    --     if not vim.tbl_contains({'mantle', 'base', 'crust'}, k)
    --       and not k:match "overlay"
    --       and not k:match "surface"
    --       and not k:match "text"
    --     then
    --       table.insert(terminal_colors, color)
    --     end
    --   end
    --
    --   shuffle(terminal_colors)
    --
    --   terminal_colors[0] = palette.crust
    --   terminal_colors[15] = palette.text
    --   
    --   -- set_terminal_colors {
    --   --   palette.crust;
    --   --   palette.red;
    --   --   palette.green;
    --   --   palette.peach;
    --   --   palette.blue;
    --   --   palette.mauve;
    --   --   palette.teal;
    --   --   palette.overlay1;
    --   --
    --   --   palette.surface1;
    --   --   palette.maroon;
    --   --   palette.green;
    --   --   palette.yellow;
    --   --   palette.lavender;
    --   --   palette.pink;
    --   --   palette.sapphire;
    --   --   palette.text;
    --   -- }
    --   set_terminal_colors(terminal_colors)
    -- end,
  }
}

for idx, plugin in ipairs(plugins) do
  if idx == activated then
    plugin.priority = 1000
    local old_init = plugin.init
    plugin.init = function(arg)
      if old_init then
        old_init(arg)
      end
      vim.cmd.colorscheme(plugin.name)
    end
  end
end

return plugins
