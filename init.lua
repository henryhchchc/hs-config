hs.g = {}

require("mm")
Modules = {
    require("modules.reload"),
    require("modules.wm"),
    require("modules.yubikey")
}

hs.fnutils.each(Modules, function(m) m.load() end)

hs.alert.defaultStyle = {
    strokeWidth     = 0,
    strokeColor     = { white = 1, alpha = 0 },
    fillColor       = { white = 0, alpha = 0.50 },
    textColor       = { white = 1, alpha = 1 },
    textFont        = ".AppleSystemUIFont",
    textSize        = 27,
    radius          = 10,
    atScreenEdge    = 0,
    fadeInDuration  = 0.15,
    fadeOutDuration = 0.15,
    padding         = nil,
}


require("modules.terminal").setup()
require("modules.menu").setup()

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)
