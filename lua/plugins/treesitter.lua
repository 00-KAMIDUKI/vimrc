return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
  event = 'User FileOpened',
  main = 'nvim-treesitter.configs',
  build = ":TSUpdate",
  config = function(plugin, opt)
    ---@type table<string, ParserInfo>
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.wgsl = {
      maintainers = { 'kamiduki' },
      install_info = {
        url = "~/repo/treesitter/tree-sitter-wgsl",
        files = { "src/parser.c", "src/scanner.c" }
      },
      filetype = 'wgsl',
    }
    require(plugin.main).setup(opt)
  end,
  opts = {
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "function" },
          ["ac"] = { query = "@class.outer", desc = "class" },
          ["ab"] = { query = "@block.outer", desc = "block" },
          ["if"] = { query = "@function.inner", desc = "function" },
          ["ic"] = { query = "@class.inner", desc = "class" },
          ["ib"] = { query = "@block.inner", desc = "block" },
        },
      },
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
        scope_incremental = '<TAB>',
      }
    },
  },
}
