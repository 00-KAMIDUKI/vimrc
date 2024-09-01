local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    -- "--branch=stable", -- latest stable release
    lazypath,
    "--depth=1"
  }
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup("plugins", {
  install = {
    colorscheme = { require 'utils.storage'.data().colorscheme },
  },
  dev = {
    path = "~/repo/nvim-plugin",
    patterns = {
      'copilot.lua'
    },
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "editorconfig",
        "gzip",
        "matchit",
        "netrwPlugin",
        "osc52",
        "rplugin",
        "shada",
        "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    }
  },
})
