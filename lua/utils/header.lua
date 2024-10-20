local texts = {
  " ",
  "                                                                    ",
  "      ███████████           █████      ██                    ",
  "     ███████████             █████                            ",
  "     ████████████████ ███████████ ███   ███████    ",
  "    ████████████████ ████████████ █████ ██████████████  ",
  "   █████████████████████████████ █████ █████ ████ █████  ",
  " ██████████████████████████████████ █████ █████ ████ █████ ",
  "██████  ███ █████████████████ ████ █████ █████ ████ ██████",
  "██████   ██  ███████████████   ██ █████████████████",
  " ",
}

---@param a string | number?
---@param b string | number?
---@param ratio number
---@return string
local function hex_interpolation(a, b, ratio)
  a = tonumber(a, 16)
  b = tonumber(b, 16)
  return string.format('%02x', math.floor((b - a) * ratio + a + 0.5))
end

local palette = {
  { '98', 'c0', '9d' },
  { 'a0', 'c4', 'a4' },
  { 'a7', 'c9', 'ab' },
  { 'af', 'cd', 'b3' },
  { 'b7', 'd1', 'ba' },
  { 'bb', '77', '44' },
  { 'bf', '7d', '47' },
  { 'c1', '83', '50' },
  { 'c3', '89', '50' },
  { 'c5', '8f', '56' },
  { 'c7', '95', '5c' },
  { 'c9', '9b', '62' },
  { 'd6', 'c4', '83' },
  { 'e0', 'c8', '85' },
  { 'e2', 'cc', '86' },
  { 'e4', 'd0', '88' },
  { 'e6', 'd4', '8a' },
  { '2e', '4e', '2a' },
  { '39', '6c', '3f' },
  { '3d', '74', '44' },
  { '41', '7c', '48' },
  { '45', '84', '4c' },
  { '49', '8c', '51' },
  { '4d', '93', '56' },
  { '51', '9b', '5a' },
  { '5c', '44', '1e' },
}

for idx, color in ipairs(palette) do
  vim.api.nvim_set_hl(0, "Header" .. idx, { fg = '#' .. color[1] .. color[2] .. color[3] })
end

local background = {}

local function set_background_color()
  background = { 'ff', 'ff', 'ff' }
  ---@type string | integer
  local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
  if bg ~= nil then
    bg = string.format('%06x', bg)
    background[1] = string.sub(bg, 1, 2)
    background[2] = string.sub(bg, 3, 4)
    background[3] = string.sub(bg, 5, 6)
  end
end

set_background_color()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_background_color })

-- PERF: stop setting hl when Alpha is now shown
local counter = 0
local timeout = function()
  local a = 36
  local ratio = math.abs(counter - a) / a
  for idx, color in ipairs(palette) do
    local function help(x) return hex_interpolation(color[x], background[x], ratio) end
    vim.api.nvim_set_hl(0, "Header" .. idx, {
      fg = ('#%s%s%s'):format(help(1), help(2), help(3)),
    })
  end
  counter = (counter + 1) % (2 * a)
end

local interval_ms = 50

local timer = vim.uv.new_timer()

local spans = {
  { { 1, 0, -1 } },
  { { 3, 0, -1 } },
  { { 6, 0, 59 },   { 19, 59, 89 },  { 3, 89, -1 } },
  { { 7, 0, 61 },   { 20, 61, -1 } },
  { { 8, 0, 44 },   { 26, 44, 47 },  { 13, 47, 89 },   { 21, 89, 118 }, { 1, 118, -1 } },
  { { 9, 0, 42 },   { 14, 42, 94 },  { 22, 94, 120 },  { 2, 120, -1 }, },
  { { 10, 0, 42 },  { 15, 42, 61 },  { 26, 61, 74 },   { 15, 74, 100 }, { 23, 100, 124 }, { 3, 124, -1 } },
  { { 11, 0, 45 },  { 16, 45, 108 }, { 24, 108, 128 }, { 4, 128, -1 } },
  { { 12, 0, 42 },  { 17, 42, 106 }, { 25, 106, 124 }, { 5, 124, -1 } },
  { { 26, 0, 100 }, { 18, 100, -1 } },
  { { 1, 0, -1 } },
  { { 1, 0, -1 } },
  { { 1, 0, -1 } },
  { { 1, 0, -1 } },
}

local content = {}

for i = 1, #texts do
  local hl = {}
  for _, span in ipairs(spans[i]) do
    table.insert(hl, { "Header" .. span[1], span[2], span[3] })
  end
  table.insert(content, {
    type = 'text',
    val = texts[i],
    opts = {
      hl = hl,
      position = 'center',
    }
  })
end

return {
  content = content,
  anim_start = function()
    _ = timer and timer:start(interval_ms, interval_ms, vim.schedule_wrap(timeout))
  end,
  anim_stop = function()
    _ = timer and timer:stop()
  end,
}
