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
  Folder = "󰉋",
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
  Text = "󰉿", -- """,
  TypeParameter = "",
  Unit = "",
  Value = "󰎠", -- "",
  Variable = "󰀫", -- "",
}

local source_names = {
  nvim_lsp = "[LSP]",
  emoji = "[Emoji]",
  path = "[Path]",
  calc = "[Calc]",
  luasnip = "[Snip]",
  buffer = "[Buf]",
  spell = "[Sp]",
  copilot = "[Copilot]",
}

return {
  {
    'neovim/nvim-lspconfig',
    -- event = 'User FileOpened',
    config = function()
      require 'lspconfig.ui.windows'.default_options = {
        border = {
          { '┌', 'NormalFloat' },
          { '─', 'NormalFloat' },
          { '┐', 'NormalFloat' },
          { '│', 'NormalFloat' },
          { '┘', 'NormalFloat' },
          { '─', 'NormalFloat' },
          { '└', 'NormalFloat' },
          { '│', 'NormalFloat' },
        },
      }

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Lsp Diagnostic Float" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Lsp Next Diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Lsp Previous Diagnostic" })
      vim.keymap.set('n', '<space>q', function() require 'trouble'.toggle 'diagnostics' end, {
        desc = "Lsp Diagnostic List"
      })

      require 'utils.servers'.setup_local_servers()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then require 'utils.document_highlight'(client, args.buf) end

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc) return { buffer = args.buf, desc = desc, noremap = false } end
          local telescope = {
            builtin = require 'telescope.builtin',
          }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts "Goto Declaration")
          vim.keymap.set('n', 'gd', telescope.builtin.lsp_definitions, opts "Goto Definition")
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts "Lsp Hover")
          vim.keymap.set('n', 'gi', telescope.builtin.lsp_implementations, opts "Goto Implementation")
          -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts "Signature Help")
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts "Add Workspace Folder")
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts "Remove Workspace Folder")
          vim.keymap.set('n', '<space>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
            opts "List Workspace Folders")
          vim.keymap.set('n', '<space>D', telescope.builtin.lsp_type_definitions, opts "Type Definition")
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts "Rename")
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts "Code Action")
          vim.keymap.set('n', 'gr', telescope.builtin.lsp_references, opts "Goto Reference")
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts "Format Code")
          vim.lsp.inlay_hint.enable(true)
        end,
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = true,
    cmd = { 'Mason' },
    opts = {},
  },
  {
    'williamboman/mason-lspconfig',
    -- event = 'User FileOpened',
    config = function()
      require('mason-lspconfig').setup()
      require 'utils.servers'.setup_mason_servers()
    end,
  },
  {
    'folke/trouble.nvim',
    lazy = true,
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
      'rafamadriz/friendly-snippets',
    },

    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      cmp.event:on('confirm_done', function() return require('nvim-autopairs.completion.cmp').on_confirm_done() end)

      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
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

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
              -- elseif has_words_before() then
              --   cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'calc' },
        },
        formatting = {
          expandable_indicator = false,
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local max_width = 60
            if max_width ~= 0 and #vim_item.abbr > max_width then
              vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. ''
            end
            vim_item.kind = kind_icons[vim_item.kind]

            if entry.source.name == "calc" then
              vim_item.kind = "󰃬"
            end

            vim_item.menu = source_names[entry.source.name]
            return vim_item
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
  },
  -- {
  --   'zbirenbaum/copilot.lua',
  --   event = 'InsertEnter',
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       keymap = {
  --         accept = "<C-S-l>",
  --         accept_word = false,
  --         accept_line = "<C-l>",
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     },
  --     filetypes = {
  --       ["*"] = true,
  --     },
  --   },
  -- },
  {
    'luozhiya/fittencode.nvim',
    event = 'InsertEnter',
    opts = {
      action = {
        identify_programming_language = { identify_buffer = false, },
      },
      inline_completion = {
        auto_triggering_completion = false,
      },
      keymaps = {
        inline = {
          ['<C-S-L>'] = 'accept_all_suggestions',
          ['<C-L>'] = 'accept_line',
          ['<C-Bslash>'] = 'triggering_completion',
        }
      },
    },
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   opts = {
  --     hint_prefix = " ",
  --     auto_close_after = 5,
  --   },
  -- },
  -- {
  --   'smjonas/inc-rename.nvim',
  --   config = true,
  -- }
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
