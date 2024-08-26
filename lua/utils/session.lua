local anchors = {
  '.git/',
  'CMakeLists.txt',
  'init.lua',
  'tsconfig.json'
}

local neotree_state = require 'utils.neotree_state'

local function is_project_dir(dir_path)
  for _, anchor in ipairs(anchors) do
    if anchor:sub(-1) == '/' then
      if vim.fn.isdirectory(dir_path .. anchor) == 1 then
        return true
      end
    else
      if vim.fn.filereadable(dir_path .. anchor) == 1 then
        return true
      end
    end
  end
  return false
end

local g_project_sessions_dir = vim.fn.stdpath 'data' .. '/core/sessions/projects/'
local g_last_session_path = vim.fn.stdpath 'data' .. '/core/sessions/last_session.vim'

-- create project sessions directory if not exists
if vim.fn.isdirectory(g_project_sessions_dir) == 0 then
  vim.fn.mkdir(g_project_sessions_dir, 'p')
end

---@type string
vim.g.current_project_dir = nil

local get_project_session_path = function()
  -- substitute '/' to '%' in project directory path
  return g_project_sessions_dir .. vim.g.current_project_dir:gsub('/', '\\%%') .. 'session.vim'
end

local function make_session(session_file_path)
  local ok, _ = pcall(vim.api.nvim_set_var, 'NeotreeStatePath')
  if not ok then
    local states = neotree_state.states()
    local show_hidden = states.show_hidden and 1 or 0
    local expanded_nodes = vim.fn.join(states.expanded_nodes, ':')
    vim.api.nvim_set_var('NeotreeStatePath', states.path)
    vim.api.nvim_set_var('NeotreeStateShowHidden', show_hidden)
    vim.api.nvim_set_var('NeotreeStateExpandedNodes', expanded_nodes)

    -- -- delete some keymaps set by which-key, causing bugs
    -- pcall(vim.api.nvim_del_keymap, 'i', '<C-R>')
    -- pcall(vim.api.nvim_del_keymap, 'i', '')
    -- pcall(vim.api.nvim_del_keymap, 'c', '<C-R>')
    -- pcall(vim.api.nvim_del_keymap, 'c', '')

    -- delete neo-tree buffer
    for _, buf_i in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value('filetype', { buf = buf_i }) == 'neo-tree' then
        vim.api.nvim_buf_delete(buf_i, { force = true })
      end
    end
  end

  vim.cmd('mksession! ' .. session_file_path)
end

local function load_session(session_file_path)
  pcall(vim.cmd.source, session_file_path)
  -- iterate all buffers and delete buffers that not exists
  for _, buffer in ipairs(vim.fn.getbufinfo()) do
    if vim.fn.filereadable(buffer.name) == 0 then
      vim.cmd('bdelete ' .. buffer.bufnr)
    end
  end
  local path = vim.g['NeotreeStatePath']
  local show_hidden = vim.g['NeotreeStateShowHidden'] == 1
  local expanded_nodes = vim.split(vim.g['NeotreeStateExpandedNodes'] or '', ':')
  neotree_state.restore { path = path, show_hidden = show_hidden, expanded_nodes = expanded_nodes }
end

local load_project_session = function()
  local project_session_path = get_project_session_path()
  -- if session file not exists, do nothing
  local s = project_session_path:gsub('\\%%', '%%')
  if vim.fn.filereadable(s) == 0 then
    return
  end
  local ok = pcall(load_session, project_session_path)
  -- delete session file if failed to load
  if not ok then
    vim.fn.delete(project_session_path)
  end
end

local function on_enter_a_directory()
  local path = vim.fn.expand '%:p'
  if vim.fn.isdirectory(path) == 0 then
    return
  end

  -- If current_project_dir already set, do nothing.
  if vim.g.current_project_dir ~= nil then return end

  if is_project_dir(path) then
    vim.g.current_project_dir = path
    load_project_session()
  end
end

local function on_exit_vim()
  if vim.g.current_project_dir ~= nil then
    make_session(get_project_session_path())
  end

  -- If buffer is not empty, save it as last session.
  if vim.fn.empty(vim.fn.expand '%') == 0 then
    make_session(g_last_session_path)
  end
end

return {
  on_enter_a_directory = on_enter_a_directory,
  on_exit_vim = on_exit_vim,
  load_last_session = function()
    if vim.fn.filereadable(g_last_session_path) == 1 then
      load_session(g_last_session_path)
    end
  end,
  select_project = function()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require "telescope.config".values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    local projects = {}
    for _, session_file in ipairs(vim.fn.globpath(g_project_sessions_dir, '*', true, 1)) do
      local t = session_file:sub(#g_project_sessions_dir + 1, -12):gsub('%%', '/')
      table.insert(projects, t)
    end

    pickers.new({}, {
      prompt_title = "projects",
      finder = finders.new_table {
        results = projects,
      },
      sorter = conf.generic_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.g.current_project_dir = selection.value
          load_project_session()
        end)
        return true
      end,
    }):find()
  end,
}
