local locally_installed = {
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
  -- pyright = {},
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

return {
  setup_locally_installed = function()
    for server_name, opts in pairs(locally_installed) do
      require 'utils.setup_server'(server_name, opts)
    end
  end
}
