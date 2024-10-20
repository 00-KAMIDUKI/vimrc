---@param desc string|nil
---@return table
local opts = function(desc)
  return {
    noremap = true,
    silent = true,
    desc = desc,
  }
end

vim.keymap.set('n', '<leader>q', ':q!', { desc = 'Quit', noremap = true })
vim.keymap.set('n', '<leader>qa', ':qa!', { desc = 'Quit All', noremap = true })
vim.keymap.set('n', '<C-a>', 'ggVG', opts 'Select All')
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', opts 'Cut')
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', vim.cmd.write, opts 'Save')

vim.keymap.set('n', '+', '<C-a>', opts 'Increment')
vim.keymap.set('n', '-', '<C-x>', opts 'Decrement')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts 'Window Left')
vim.keymap.set('n', '<C-j>', '<C-w>j', opts 'Window Down')
vim.keymap.set('n', '<C-k>', '<C-w>k', opts 'Window Up')
vim.keymap.set('n', '<C-l>', '<C-w>l', opts 'Window Right')

-- Buffer Navigation
vim.keymap.set('n', '<Tab>', vim.cmd.bn, opts 'Buffer Next')
vim.keymap.set('n', '<S-Tab>', vim.cmd.bp, opts 'Buffer Previous')
vim.keymap.set('n', '<M-q>', require 'utils.buffer_delete', opts 'Buffer Delete')
vim.keymap.set('n', '<leader>x', require 'utils.buffer_delete', opts 'Buffer Delete')

-- Search Highlight
for _, key in ipairs { 'n', 'N', '*', '#' } do
  vim.keymap.set('n', key, function()
    vim.opt_local.hlsearch = true
    local _, err = pcall(vim.api.nvim_command, 'silent normal! ' .. key)
    if err then
      vim.notify_once(err:match ': (.*)', vim.log.levels.WARN)
    end
  end)
end

vim.keymap.set('n', '<Esc>', require 'utils.exit_hlsearch')

-- Tab Navigation
vim.keymap.set('n', '<M-Tab>', vim.cmd.tabnext, opts 'Tab Next')
vim.keymap.set('n', '<M-S-Tab>', vim.cmd.tabprevious, opts 'Tab Previous')
vim.keymap.set('n', '<leader><Tab>', vim.cmd.tabnext, opts 'Tab Next')

-- Window Resizing
vim.keymap.set('n', '<C-Up>', '<cmd>resize +1<CR>', opts 'Resize Up')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -1<CR>', opts 'Resize Down')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize +1<CR>', opts 'Resize Left')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize -1<CR>', opts 'Resize Right')

vim.keymap.set('v', 'p', 'P', opts 'Paste') -- paste without yank
vim.keymap.set('v', '<', '<gv', opts 'Indent Left')
vim.keymap.set('v', '>', '>gv', opts 'Indent Right')

vim.keymap.set('v', '<S-Up>', '<Up>', opts 'Up')
vim.keymap.set('v', '<S-Down>', '<Down>', opts 'Down')

vim.keymap.set('i', 'kk', '<Esc>', opts 'Exit Insert Mode')

vim.keymap.set('n', 'q:', '<Nop>', { noremap = true })
vim.keymap.set('n', 'q;', 'q:')

vim.keymap.set('n', 'u', function() vim.cmd [[silent undo]] end, opts 'undo')
vim.keymap.set('n', '', function() vim.cmd [[silent redo]] end, opts 'redo')

vim.keymap.set('n', '<C-LeftMouse>', function()
  vim.cmd [[exe "silent normal! \<LeftMouse>"]]

  local uri = vim.fn.expand "<cfile>"
  if uri:match 'https?://' then
    vim.ui.open(uri)
    return
  end

  local _, err = pcall(vim.api.nvim_command, [[silent normal! ]])
  if err then vim.notify_once(err:match ': (.*)', vim.log.levels.WARN) end
end, opts 'Open URI or Jump to Definition')

---@return string[]
local function visual_selected()
  local start_line, start_col = table.unpack(vim.fn.getpos 'v', 2, 3)
  local end_line, end_col = table.unpack(vim.fn.getpos ".", 2, 3)

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  lines[1] = lines[1]:sub(start_col, -1)
  local n_lines = math.abs(end_line - start_line) + 1
  lines[n_lines] = lines[n_lines]:sub(1, n_lines == 1 and end_col - start_col + 1 or end_col)
  return lines
end

local function line_selected()
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line "."

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
end

local function selected(mode)
  return mode == 'V' and line_selected() or visual_selected()
end

---@param s string
---@return string
local escaped = function(s)
  s = s:gsub('([%$.^*+?{}/\\\\%(%)%[%]])', '\\%1')
  s = s:gsub('([%])', '%1')
  s = s:gsub('\n', '\\n')
  return s
end

vim.keymap.set('v', '?', function()
  local text = escaped(table.concat(selected(vim.fn.mode()), '\n'))
  vim.api.nvim_input('/' .. text)
end, opts 'Search Selected')

vim.keymap.set('v', '<leader>t', function()
  local mode = vim.fn.mode()
  local lines = selected(mode)
  require 'utils.translate' {
    text = table.concat(lines, '\n'),
    cb = function(arg)
      if arg.ok then
        vim.notify_once(arg.res)
      else
        vim.notify_once('Translation failed', vim.log.levels.WARN)
      end
    end,
  }
end, opts 'Translate')
