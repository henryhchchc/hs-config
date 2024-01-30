local MM = {}

if not hs.modules then
  hs.modules = {}
end

function MM.define(M)
  assert(type(M) == "table")
  assert(type(M.id) == "string")
  assert(type(M.name) == "string")
  assert(type(M.icon) == "string")

  function M.enable()
    M.enableFn()
    hs.settings.set(M.id, true)
  end

  function M.disable()
    M.disableFn()
    hs.settings.set(M.id, false)
  end

  function M.isEnabled()
    return hs.settings.get(M.id)
  end

  function M.load()
    if M.isEnabled() then
      M.enable()
    end
  end

  return M
end

return MM
