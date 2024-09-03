local function reload(files)
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      hs.notify.new({
        title = "Configuration",
        autoWithdraw = true,
        informativeText = "(Re)loading Hammerspoon config",
        withdrawAfter = 3,
      }):send()
      hs.console.clearConsole()
      hs.reload()
      return
    end
  end
end

local mm = require("mm")

local moduleId = "reload"
if hs.modules[moduleId] then
  return hs.modules[moduleId]
end

local M = {
  id = moduleId,
  name = "Auto Config Reload",
  icon = "􁐂 ",
}

hs.modules[moduleId] = mm.define(M)

function M.enableFn()
  hs.modules[moduleId].watcher:start()
end

function M.disableFn()
  hs.modules[moduleId].watcher:stop()
end

hs.modules[moduleId].watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload)
return hs.modules[moduleId]
