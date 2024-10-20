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
          if client then require 'utils.document_highlight' (client, args.buf) end

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc) return { buffer = args.buf, desc = desc, noremap = false } end
          local telescope = {
            builtin = require 'telescope.builtin',
          }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts "Goto Declaration")
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts "Lsp Hover")
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts "Add Workspace Folder")
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts "Remove Workspace Folder")
          vim.keymap.set('n', '<space>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
            opts "List Workspace Folders")
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts "Rename")
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts "Code Action")
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts "Format")
          vim.keymap.set('v', '<space>f', function()
            vim.lsp.buf.format {
              range = {
                start   = { vim.api.nvim_buf_get_mark(0, '<')[0], 0 },
                ['end'] = { vim.api.nvim_buf_get_mark(0, '>')[0], 0 },
              },
              async = true
            }
          end, opts "Range Format")
          vim.keymap.set('n', 'g,', function() vim.lsp.buf.typehierarchy 'subtypes' end, opts "Subtypes")
          vim.keymap.set('n', 'g.', function() vim.lsp.buf.typehierarchy 'supertypes' end, opts "Supertypes")
          vim.keymap.set('n', 'gr', telescope.builtin.lsp_references, opts "Goto Reference")
          vim.keymap.set('n', 'gd', telescope.builtin.lsp_definitions, opts "Goto Definition")
          vim.keymap.set('n', 'gI', telescope.builtin.lsp_implementations, opts "Goto Implementation")
          vim.keymap.set('n', 'gt', telescope.builtin.lsp_type_definitions, opts "Type Definition")
          vim.keymap.set('n', 'gi', telescope.builtin.lsp_incoming_calls, opts "Incoming Calls")
          vim.keymap.set('n', 'go', telescope.builtin.lsp_outgoing_calls, opts "Outgoing Calls")
          vim.keymap.set('n', '<leader>fs', telescope.builtin.lsp_workspace_symbols, opts "Workspace Symbols")

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
      require 'mason-lspconfig'.setup()
      require 'utils.servers'.setup_mason_servers()
    end,
  },
  {
    'folke/trouble.nvim',
    lazy = true,
    opts = {},
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
