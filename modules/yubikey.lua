local function usbDeviceCallback(event)
    local productName = event["productName"]
    local eventType = event["eventType"]
    if event["vendorID"] == 0x1050 then
        if eventType == "added" then
            hs.notify.new({
                title = "YubiKey 🔑",
                autoWithdraw = true,
                informativeText = productName .. " is connected."
            }):send()
        elseif eventType == "removed" then
            local isShiftHold = hs.eventtap.checkKeyboardModifiers()["shift"]
            if isShiftHold then
                hs.notify.new({
                    title = "YubiKey 🔑",
                    autoWithdraw = true,
                    informativeText = productName .. " is removed."
                }):send()
            else
                hs.caffeinate.lockScreen()
            end
        end
    end
end

local mm = require("mm")

local moduleId = "yubikey"
if hs.modules[moduleId] then
    return hs.modules[moduleId]
end

local M = {
    id = moduleId,
    name = "Yubikey Autolock",
    icon = "􀟕 "
}

hs.modules[moduleId] = mm.define(M)

function M.enableFn()
    hs.modules[moduleId].watcher:start()
end

function M.disableFn()
    hs.modules[moduleId].watcher:stop()
end

hs.modules[moduleId].watcher = hs.usb.watcher.new(usbDeviceCallback)
return hs.modules[moduleId]
