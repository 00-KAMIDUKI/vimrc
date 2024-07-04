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

local duplicates = {
  buffer = 1,
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}

return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig',
      'folke/trouble.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      vim.lsp.set_log_level 'ERROR'
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

      require('mason').setup()
      require('mason-lspconfig').setup()

      local lspconfig = require 'lspconfig'

      ---@param server_name string
      ---@param opts table
      ---@param update_capability function | nil
      local function setup_server(server_name, opts, update_capability)
        opts.capabilities = require 'cmp_nvim_lsp'.default_capabilities(opts.capabilities)
        if update_capability ~= nil then
          update_capability(opts.capabilities)
        end
        lspconfig[server_name].setup(opts)
      end

      local mason_handlers = {
        function(server_name)
          setup_server(server_name, {})
        end,
      }

      local mason_handlers_additional = {
        mesonlsp = {
          root_dir = require('lspconfig.util').root_pattern('meson_options.txt', 'meson.options', '.git'),
        },
        jsonls = {
          filetypes = { "json", "jsonc" },
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig*.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
              },
              validate = { enable = true },
            },
          },
        },
        volar = {
          filetypes = { "vue", "typescript", "javascript" },
        },
      }

      -- FIXME: update_capabilities won't work
      for server_name, opts, update_capability in pairs(mason_handlers_additional) do
        mason_handlers[server_name] = function()
          setup_server(server_name, opts, update_capability)
        end
      end

      require('mason-lspconfig').setup_handlers(mason_handlers)

      local servers = {
        lua_ls = {
          -- settings = {
          --   Lua = {
          --     workspace = {
          --       library = vim.api.nvim_get_runtime_file("", true),
          --     },
          --     diagnostics = {
          --       globals = { "vim", "NONE" }
          --     },
          --   },
          -- }
        },
        rust_analyzer = {},
        clangd = {
          cmd = {
            "clangd",
            "--header-insertion=never",
            "--clang-tidy",
          },
          update_capabilities = function(capabilities)
            capabilities.offsetEncoding = "utf-8"
          end,
        },
        pyright = {},
        tsserver = {
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = '/usr/lib/node_modules/@vue/typescript-plugin',
                languages = { 'typescript', 'javascript', 'vue' },
              },
            },
          },
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
            'vue',
          },
        },
        zls = {},
        hls = {},
      }

      for server_name, opts in pairs(servers) do
        setup_server(server_name, opts, opts.update_capabilities)
      end

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Lsp Diagnostic Float" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Lsp Next Diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Lsp Previous Diagnostic" })
      vim.keymap.set('n', '<space>q', function() require 'trouble'.toggle 'diagnostics' end,
        { desc = "Lsp Diagnostic List" })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc) return { buffer = ev.buf, desc = desc, noremap = false } end
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts "Goto Declaration")
          vim.keymap.set('n', 'gd', require 'telescope.builtin'.lsp_definitions, opts "Goto Definition")
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts "Lsp Hover")
          vim.keymap.set('n', 'gi', require 'telescope.builtin'.lsp_implementations, opts "Goto Implementation")
          -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts "Signature Help")
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts "Add Workspace Folder")
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts "Remove Workspace Folder")
          vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opts "List Workspace Folders")
          vim.keymap.set('n', '<space>D', require 'telescope.builtin'.lsp_type_definitions, opts "Type Definition")
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts "Rename")
          -- vim.keymap.set('n', '<space>rn', function()
          --   local cword = vim.fn.expand('<cword>')
          --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':IncRename ' .. cword, true, false, true), 'n', false)
          -- end, opts "Rename")
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts "Code Action")
          vim.keymap.set('n', 'gr', require 'telescope.builtin'.lsp_references, opts "Goto Reference")
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts "Format Code")
          vim.lsp.inlay_hint.enable(true)
        end,
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'zbirenbaum/copilot-cmp',
      { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
      'rafamadriz/friendly-snippets',
    },

    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

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
            elseif luasnip.expand_or_jumpable() then
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
          {
            name = 'spell',
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
            },
          },
        },

        formatting = {
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
            vim_item.dup = duplicates[entry.source.name] or 0
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
  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-S-l>",
          accept_word = false,
          accept_line = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        ["*"] = true,
      }
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
}
