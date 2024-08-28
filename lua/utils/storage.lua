local path = vim.fn.stdpath 'data' .. '/core/storage.lua'

---@class global
---@field transparency? number
---@field scroll_animation_length? number
---@field cursor? cursor

---@class neovide
---@field global? global
---@field option? { blend?: number }

---@class cursor
---@field vfx? vfx

---@class vfx
---@field mode? string
---@field opacity? string
---@field particle? particle

---@class particle
---@field lifetime? number
---@field density? number
---@field speed? number
---@field phase? number
---@field curl? number

---@class data
---@field colorscheme? string
---@field transparent_background? boolean
---@field neovide? neovide
local data

local function init()
  local ok, result = pcall(dofile, path)
  if ok then data = result end
end

return {
  data = function()
    if not data then init() end
    return data
  end,
  persist = function()
    local f = io.open(path, 'w');
    if not f then
      vim.notify('Failed to persist storage', vim.log.levels.ERROR)
      return
    end
    f:write('return ' .. vim.inspect(data))
    f:flush()
    f:close()
  end,
}
