local M = {}

function M.loadForMenu(symbol, size)
  size = size or 18
  local sizePt = size / 96.0 * 72.0 * 2
  local sym = string.sub(symbol, 1, 4)
  local canvas = hs.canvas.new({ x = 0, y = 0, h = size * 2, w = size * 2 })
  canvas:appendElements({ type = "text", text = sym, textSize = sizePt, textAlignment = "center" })
  local image = canvas:imageFromCanvas():size({ w = size, h = size }):template(true)
  return image
end

return M
