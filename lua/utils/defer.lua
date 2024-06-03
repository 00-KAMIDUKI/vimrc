local functions = {}

return {
  add = function(fn)
    table.insert(functions, fn)
  end,
  run = function()
    for _, fn in ipairs(functions) do
      fn()
    end
  end,
}
