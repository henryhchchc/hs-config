local M = {}

function M.startOrFocusTerminal()
    hs.application.launchOrFocusByBundleID("net.kovidgoyal.kitty")
end

function M.setup()
    hs.hotkey.bind({ "cmd", "control" }, "t", M.startOrFocusTerminal)
end

return M
