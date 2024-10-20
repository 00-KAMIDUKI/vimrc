local kind_icons = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "󰏿", -- "",
  Constructor = "", -- "",
  Enum = "", -- "",
  EnumMember = "", -- "",
  Event = "",
  Field = "",
  File = "",
  Folder = "󰉖",
  Function = "󰊕", -- "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "󰟢",
  Number = "󰎠", -- "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "󰉾", -- "",
  Struct = "",
  Text = "󰉿", -- "",
  TypeParameter = "",
  Unit = "",
  Value = "󰫧", -- "",
  Variable = "",
}

local source_names = {
  nvim_lsp = "lsp",
  luasnip = "snip",
  buffer = "buf",
  cmdline = "",
}

local cmp = {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    {
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
      lazy = true,
      dependencies = 'rafamadriz/friendly-snippets',
    },
  },

  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done)

    -- local has_words_before = function()
    --   local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    -- end

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<Left>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else fallback()
          end
        end),
        ['<Right>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else fallback()
          end
        end),

        -- luasnip
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- nvim builtin snippet
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif vim.snippet.active { direction = 1 } then
        --     vim.snippet.jump(1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        --
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif vim.snippet.active { direction = -1 } then
        --     vim.snippet.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      },
      sources = cmp.config.sources {
        -- { name = 'snippets' },
        { name = "luasnip" },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
      },
      formatting = {
        expandable_indicator = false,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          local max_width = 60
          if max_width ~= 0 and #item.abbr > max_width then
            item.abbr = string.sub(item.abbr, 1, max_width - 1) .. ''
          end
          item.kind = kind_icons[item.kind]

          if entry.source.name == "calc" then
            item.kind = "󰃬"
          end

          item.menu = source_names[entry.source.name] or entry.source.name
          return item
        end,
      },
    }

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline('?', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })
  end,
}

-- local nvim_snippets = {
--   "garymjr/nvim-snippets",
--   lazy = true,
--   opts = {
--     friendly_snippets = true
--   },
-- }

return {
  cmp,
  -- nvim_snippets,
}
