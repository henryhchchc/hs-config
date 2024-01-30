local function centerWindow()
  local currentWindow = hs.window.focusedWindow()
  local wf = currentWindow:frame()
  local sf = currentWindow:screen():frame()
  local centerRect = {
    x = sf.x + (sf.w - wf.w) / 2,
    y = sf.y + (sf.h - wf.h) / 2,
    w = wf.w,
    h = wf.h,
  }
  currentWindow:move(centerRect, currentWindow:screen(), true)
end

local function isInUnitRect(window, rectSpec)
  local uf = hs.geometry(rectSpec)
  local sf = window:screen():frame()
  local wf = window:frame():toUnitRect(sf)
  return true
      and math.abs(uf.x - wf.x) < 0.01
      and math.abs(uf.y - wf.y) < 0.01
      and math.abs(uf.w - wf.w) < 0.01
      and math.abs(uf.h - wf.h) < 0.01
end

local left40Rect = { 0, 0, 0.4, 1 }
local left50Rect = { 0, 0, 0.5, 1 }
local left60Rect = { 0, 0, 0.6, 1 }

local right40Rect = { 0.6, 0, 0.4, 1 }
local right50Rect = { 0.5, 0, 0.5, 1 }
local right60Rect = { 0.4, 0, 0.6, 1 }

local function multiLevelSnap(targets)
  return function ()
    local currentWindow = hs.window.focusedWindow()
    if currentWindow == nil then
      return
    end
    local snapTarget = targets[1]
    for idx, target in ipairs(targets) do
      if isInUnitRect(currentWindow, target) then
        snapTarget = targets[idx + 1]
      end
    end
    currentWindow:moveToUnit(snapTarget or targets[1])
  end
end

local snapLeft = multiLevelSnap({ left50Rect, left40Rect, left60Rect })
local snapRight = multiLevelSnap({ right50Rect, right40Rect, right60Rect })


local function highlightWindow(w)
  local c = hs.canvas.new(w:frame())
  local wf = { x = 0, y = 0, w = w:frame().w, h = w:frame().h }
  local radii = w:isFullScreen() and { xRadius = 0, yRadius = 0 } or { xRadius = 10, yRadius = 10 }
  local frameThickness = 5
  local frameColor = hs.drawing.color.colorsFor("System").controlAccentColor
  c:appendElements(
    { type = "rectangle", action = "build", roundedRectRadii = radii, reversePath = true, padding = frameThickness }
    ,
    { type = "rectangle", action = "clip", frame = wf, roundedRectRadii = radii },
    { type = "rectangle", action = "fill", frame = wf, roundedRectRadii = radii, fillColor = frameColor }
  )
  c:show()
  c:hide(1)
end

local function switchToWindowLeft()
  local currentWindow = hs.window.focusedWindow()
  local candidate = hs.fnutils.find(
    currentWindow:windowsToWest(hs.window.orderedWindows(), true, false),
    function (w) return w:isStandard() and w:screen() == currentWindow:screen() end
  )
  if candidate then
    candidate:focus()
    highlightWindow(candidate)
  elseif currentWindow ~= hs.window.desktop() then
    highlightWindow(currentWindow)
  end
end

local function switchToWindowRight()
  local currentWindow = hs.window.focusedWindow()
  local candidate = hs.fnutils.find(
    currentWindow:windowsToEast(hs.window.orderedWindows(), true, false),
    function (w) return w:isStandard() and w:screen() == currentWindow:screen() end
  )
  if candidate then
    candidate:focus()
    highlightWindow(candidate)
  elseif currentWindow ~= hs.window.desktop() then
    highlightWindow(currentWindow)
  end
end

local function almostMaximize()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:moveToUnit({ 0.15, 0.1, 0.7, 0.8 })
end

local function toggleMaximize()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:maximize()
end

local function moveToScreenLeft()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:moveOneScreenWest(true, true)
end

local function moveToScreenRight()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:moveOneScreenEast(true, true)
end

local function moveToScreenUp()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:moveOneScreenNorth(true, true)
end

local function moveToScreenDown()
  local currentWindow = hs.window.focusedWindow()
  currentWindow:moveOneScreenSouth(true, true)
end

local function zoomWindow(scalingFactor)
  return function ()
    local currentWindow = hs.window.focusedWindow()
    local wf = currentWindow:frame()
    local sf = currentWindow:screen():frame()
    currentWindow:setFrame({
      x = math.max(sf.x, wf.x + (1 - scalingFactor) / 2.0 * wf.w),
      y = math.max(sf.y, wf.y + (1 - scalingFactor) / 2.0 * wf.h),
      w = wf.w * scalingFactor,
      h = wf.h * scalingFactor,
    })
  end
end

local function moveSpliter(offset)
  local currentWindow = hs.window.focusedWindow()
  local wf = currentWindow:frame()
  local sf = currentWindow:screen():frame()
  local actualOffset = offset * sf.w
  if (wf.x - sf.x) > 2 then
    actualOffset = -actualOffset
  end
  local nf = {
    x = wf.x,
    y = wf.y,
    w = wf.w + actualOffset,
    h = wf.h,
  }
  currentWindow:setFrame(nf, 0)
end

local function equalizeSplitWindows()
  local currentWindow = hs.window.focusedWindow()
  local wf = currentWindow:frame()
  local sf = currentWindow:screen():frame()
  if currentWindow:isFullScreen() and (wf.w < sf.w - 10) then
    local nf = { x = wf.x, y = wf.y, h = sf.h, w = sf.w / 2 }
    currentWindow:setFrame(nf, 0)
  end
end

local cmdControlHHandler = function ()
  local currentWindow = hs.window.focusedWindow()
  if currentWindow:isFullScreen() then
    moveSpliter(-0.05)
  else
    snapLeft()
  end
end
local cmdControlHHoldHandler = function ()
  local currentWindow = hs.window.focusedWindow()
  if currentWindow:isFullScreen() then
    moveSpliter(-0.01)
  end
end
local cmdControlLHandler = function ()
  local currentWindow = hs.window.focusedWindow()
  if currentWindow:isFullScreen() then
    moveSpliter(0.05)
  else
    snapRight()
  end
end
local cmdControlLHoldHandler = function ()
  local currentWindow = hs.window.focusedWindow()
  if currentWindow:isFullScreen() then
    moveSpliter(0.01)
  end
end

local mm = require("mm")

local moduleId = "wm"
if hs.modules[moduleId] then
  return hs.modules[moduleId]
end

local M = {
  id = moduleId,
  name = "Window Manager",
  icon = "􀢌 ",
}

hs.modules[moduleId] = mm.define(M)

function M.enableFn()
  hs.window.animationDuration = 0.2
  hs.fnutils.each(hs.modules[moduleId].hotKeys, function (k)
    k:enable()
  end)
end

function M.disableFn()
  hs.fnutils.each(hs.modules[moduleId].hotKeys, function (k)
    k:disable()
  end)
end

hs.modules[moduleId].hotKeys = {
  hs.hotkey.new({ "cmd", "control" }, "c", centerWindow),

  hs.hotkey.new({ "cmd", "control" }, "h", cmdControlHHandler, nil, cmdControlHHoldHandler),
  hs.hotkey.new({ "cmd", "control" }, "l", cmdControlLHandler, nil, cmdControlLHoldHandler),

  hs.hotkey.new({ "cmd", "control" }, "j", switchToWindowRight),
  hs.hotkey.new({ "cmd", "control" }, "k", switchToWindowLeft),

  hs.hotkey.new({ "cmd", "control" }, "n", almostMaximize),
  hs.hotkey.new({ "cmd", "control" }, "m", toggleMaximize),
  hs.hotkey.new({ "cmd", "control" }, "=", equalizeSplitWindows),

  hs.hotkey.new({ "cmd", "control", "shift" }, "-", zoomWindow(0.9), nil, zoomWindow(0.95)),
  hs.hotkey.new({ "cmd", "control", "shift" }, "=", zoomWindow(1.1), nil, zoomWindow(1.05)),

  hs.hotkey.new({ "cmd", "control", "shift" }, "h", moveToScreenLeft),
  hs.hotkey.new({ "cmd", "control", "shift" }, "j", moveToScreenDown),
  hs.hotkey.new({ "cmd", "control", "shift" }, "k", moveToScreenUp),
  hs.hotkey.new({ "cmd", "control", "shift" }, "l", moveToScreenRight),
}

return hs.modules[moduleId]
