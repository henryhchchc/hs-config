local function launch_term()
    hs.application.launchOrFocus("WezTerm")
end

local mm = require("mm")

local moduleId = "term"
if hs.modules[moduleId] then
    return hs.modules[moduleId]
end

local M = {
    id = moduleId,
    name = "Terminal Shortcut",
    icon = "􀩼 "
}

hs.modules[moduleId] = mm.define(M)

hs.modules[moduleId].hotKey = hs.hotkey.new({ "cmd", "control" }, "return", launch_term)

function M.enableFn()
    hs.modules[moduleId].hotKey:enable()
end

function M.disableFn()
    hs.modules[moduleId].hotKey:disable()
end

return hs.modules[moduleId]
