---@alias Body {cond: any, and_then: any, or_else: any}

---@param body Body
return function (body)
  if body.cond then
    return body.and_then
  else
    return body.or_else
  end
end
