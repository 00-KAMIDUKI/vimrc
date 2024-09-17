return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
  event = 'User FileOpened',
  main = 'nvim-treesitter.configs',
  build = ":TSUpdate",
  opts = {
    textobjects = {
      select = {
        enable = true,
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
