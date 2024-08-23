return {
  'luukvbaal/statuscol.nvim',
  event = 'VeryLazy',
  config = function()
    local builtin = require "statuscol.builtin"
    require('statuscol').setup {
      ft_ignore = {
        'neo-tree'
      },
      segments = {
        {
          text = { builtin.foldfunc },
          click = "v:lua.ScFa",
        },
        {
          text = { "%s" },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc, ' ' },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        }
      },
    }
  end,
}
