local locally_installed = {
  lua_ls = {},
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
  -- pyright = {},
  ts_ls = {
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
      },
    },
  },
  volar = {
    filetypes = { "vue", "typescript", "javascript" },
  },
}

local setup_server = require 'utils.setup_server'

local mason_handlers = {
  setup_server,
}

return {
  setup_local_servers = function()
    for server_name, opts in pairs(locally_installed) do
      setup_server(server_name, opts)
    end
  end,
  setup_mason_servers = function()
    for server_name, opts in pairs(mason_handlers_additional) do
      mason_handlers[server_name] = function()
        setup_server(server_name, opts)
      end
    end
    require('mason-lspconfig').setup_handlers(mason_handlers)
  end,
}
