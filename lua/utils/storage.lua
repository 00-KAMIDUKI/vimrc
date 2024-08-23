local path = vim.fn.stdpath 'data' .. '/core/storage.lua'

---@type { colorscheme?: string, transparent_background?: boolean }
local content

local function init()
  local ok, result = pcall(dofile, path)
  if ok then content = result end
end

return {
  data = function()
    if not content then init() end
    return content
  end,
  persist = function()
    local f = io.open(path, 'w');
    if not f then
      vim.notify('Failed to persist storage', vim.log.levels.ERROR)
      return
    end
    f:write('return ' .. vim.inspect(content))
    f:flush()
    f:close()
  end,
}
