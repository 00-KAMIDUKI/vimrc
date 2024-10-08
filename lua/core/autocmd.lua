vim.api.nvim_create_autocmd({
  'BufRead',
  'BufNewFile',
}, {
  desc = 'Set filetype to glsl',
  pattern = '*.frag,*.vert,*.geom,*.comp,*.tesc,*.tese',
  command = 'setlocal filetype=glsl',
})

vim.api.nvim_create_autocmd({
  'BufRead',
  'BufNewFile',
}, {
  desc = 'Set filetype to hyprlang',
  pattern = { 'hypr*.conf', '*.hl' },
  command = 'setlocal filetype=hyprlang',
})

vim.api.nvim_create_autocmd({
  'BufRead',
  'BufNewFile',
}, {
  desc = 'Set filetype to rasi',
  pattern = '*.rasi',
  command = 'setlocal filetype=rasi',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'wgsl',
  callback = function()
    vim.opt.commentstring = '// %s'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'kdl',
  callback = function()
    vim.opt.commentstring = '// %s'
  end,
})

local session = require 'utils.session'

vim.api.nvim_create_autocmd('VimLeave', {
  callback = session.on_exit_vim,
  nested = true,
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = session.on_enter_a_directory,
  nested = true,
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function() end,
  nested = true,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  desc = "Change input method to English when leaving insert mode",
  pattern = { "*" },
  callback = require('utils.ime').leave_insert,
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  desc = "Restore input method when entering insert mode",
  pattern = { "*" },
  callback = require('utils.ime').enter_insert,
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = require 'utils.exit_hlsearch',
})

vim.api.nvim_create_user_command("MakeDirectory", function()
  ---@diagnostic disable-next-line: missing-parameter
  local path = vim.fn.expand "%"
  local dir = vim.fn.fnamemodify(path, ":p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  else
    vim.notify("Directory already exists", vim.diagnostic.severity.WARN, { title = "Nvim" })
  end
end, { desc = "Create directory if it doesn't exist" })

vim.api.nvim_create_user_command('ToggleTransparent', require 'utils.transparent'.toggle, {})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, name in ipairs {
      'SpellBad',
      'SpellCap',
      'SpellLocal',
      'SpellRare',
    } do
      vim.cmd('hi! ' .. name .. ' guifg=none')
    end
  end,
  desc = 'Set transparent background for some highlight groups.',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('FileOpened', {}),
  callback = require('utils.on_file_opened').callback,
})
