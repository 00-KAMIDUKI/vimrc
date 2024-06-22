vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noselect"
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.signcolumn = "auto:1"
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.title = true
vim.opt.mousescroll = 'ver:3,hor:3'
vim.opt.fillchars = [[foldopen:,foldsep: ,foldclose:,vert: ]]
vim.opt.laststatus = 3 -- always and only last window

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitkeep = 'screen'

vim.opt.whichwrap:append "<,>,[,],h,l"

vim.opt.spell = true
vim.opt.spelloptions:append "camel"

vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.sessionoptions = {
  'buffers',
  'curdir',
  'folds',
  'help',
  'tabpages',
  'winsize',
  -- 'options',
  'globals',
}

vim.opt.foldnestmax = 1
vim.opt.foldcolumn = 'auto' -- '0' is not bad
vim.opt.foldlevel = 99      -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

require('utils.set_diag_signs')()
