vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
vim.o.mouse = "a"
vim.o.mousemoveevent = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

if vim.fn.argc() > 0 then
  vim.o.autochdir = true
end

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 1
vim.o.signcolumn = "auto:1"
vim.o.wrap = false
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:-Cursor"
vim.o.showmode = false
vim.o.title = true
vim.o.mousescroll = 'ver:3,hor:3'
vim.o.fillchars = [[foldopen:,foldsep: ,foldclose:,vert: ]]
vim.o.laststatus = 3 -- always and only last window

vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitkeep = 'screen'

vim.opt.whichwrap:append "<,>,[,],h,l"

vim.o.spell = true
vim.opt.spelloptions:append "camel"

vim.o.undofile = true
vim.o.swapfile = false
vim.o.updatetime = 0 -- CursorHold event

vim.opt.sessionoptions = {
  'buffers',
  'curdir',
  'folds',
  'help',
  'tabpages',
  'winsize',
  'globals',
}

vim.o.foldnestmax = 1
vim.o.foldcolumn = 'auto' -- '0' is not bad
vim.o.foldlevel = 99      -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
