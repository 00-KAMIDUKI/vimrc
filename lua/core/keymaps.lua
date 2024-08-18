---@param desc string|nil
---@return table
local opts = function(desc)
  return {
    noremap = true,
    silent = true,
    desc = desc,
  }
end

vim.keymap.set('n', '<leader>t', require 'utils.spawn_term', opts 'Spawn Terminal')
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
vim.keymap.set('n', '<M-H>', vim.cmd.bp, opts 'Buffer Previous')
vim.keymap.set('n', '<M-L>', vim.cmd.bn, opts 'Buffer Next')
vim.keymap.set('n', '<M-Left>', vim.cmd.bp, opts 'Buffer Previous')
vim.keymap.set('n', '<M-Right>', vim.cmd.bn, opts 'Buffer Next')
vim.keymap.set('n', '<M-q>', require 'utils.buffer_delete', opts 'Buffer Delete')

-- Search Highlight
for _, key in ipairs { 'n', 'N', '*', '#' } do
  vim.keymap.set('n', key, function()
    vim.opt_local.hlsearch = true
    local _, err = pcall(vim.api.nvim_command, 'silent normal! ' .. key)
    if err then
      vim.notify(err:match(': (.*)'), vim.log.levels.WARN)
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

vim.keymap.set('n', 'q:', '<Nop>')

vim.keymap.set('n', 'u', function() vim.cmd [[silent undo]] end, opts 'undo')
vim.keymap.set('n', '', function() vim.cmd [[silent redo]] end, opts 'redo')
