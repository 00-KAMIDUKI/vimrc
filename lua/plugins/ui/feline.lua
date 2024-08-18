return {
  'freddiehaddad/feline.nvim',
  opts = {
    components = {
      active = {
        {
          {
            provider = '0',
            icon = {
              str = ' ! ',
              hl = '@lsp.type.string',
            }
          },
          {},
          {},
        },
        {
          {},
          {},
          {},
        },
      },
    },
  },
  -- config = function(_, opts)
  --   require('feline').setup()
  --   -- require('feline').statuscolumn.setup()
  --
  --   require('feline').use_theme()
  -- end,
}
