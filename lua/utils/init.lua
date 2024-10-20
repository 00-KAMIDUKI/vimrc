return {
  ---@param f1 function
  ---@param ... function
  ---@return function
  compose = function(f1, ...)
    local fs = { ... }
    return function(...)
      local acc = f1(...)
      for _, f in ipairs(fs) do
        acc = f(acc)
      end
      return acc
    end
  end,
  id = function(...)
    return ...
  end,
}
