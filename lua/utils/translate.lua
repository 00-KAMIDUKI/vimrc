local storage = require "utils.storage"

local function translate_url()
  local res = storage.data().translate_url
  if not res then
    vim.ui.input({ prompt = "url" }, function (input)
      res = input
    end)
    storage.data().translate_url = res
    storage.persist()
  end
  return res
end

---@param args { text?: string, cb: fun(obj: { res?: string, ok: boolean, err?: string })}
return function(args)
  if not args.text then
    args.cb {
      ok = false
    }
  end
  vim.system({
    vim.fn.stdpath('config') .. '/node/translate.js',
    translate_url(),
    args.text,
    'auto',
    'zh'
  }, {}, function(obj)
    if obj.code == 0 then
      args.cb {
        ok = true,
        res = obj.stdout,
      }
    end
  end)
end
