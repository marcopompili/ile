--------------------------------------------------------------------------------
-- Histogram widget
-- By Marco Pompili
--------------------------------------------------------------------------------

-- Base
local gears  = require("gears")
local gtable = gears.table

-- Widget
local wibox = require("wibox")
local base  = wibox.widget.base

-- Theming
-- local beautiful = require("beautiful")

local properties = {
  "width",
  "height",
  "color",
  "background_color",
  "text_color",
  "colwidth",
  "spacing",
  "font",
  "font_size",
  "title",
  "values",
  "qt"
}

local histogram = { mt = {} }

function histogram:draw(_, cr)
  local colwidth = self._private.colwidth
  local spacing  = colwidth + self._private.spacing
  local floor    = self._private.height
  local i        = 0

  cr:set_source(gears.color(self._private.color))

  cr:select_font_face(self._private.font)
  cr:set_font_size(self._private.font_size)

  if self._private.title then
    local title = self._private.title
    local extents = cr:text_extents(title)
    cr:move_to(self._private.width / 2 - extents.width / 2, 10)
    cr:show_text(title)
  end

  while i < self._private.qt do
    local s = i * spacing
    cr:rectangle(s, floor, colwidth, -self._private.values[i].usage)
    i = i + 1
  end

  cr:fill()

  i = 0

  while i < self._private.qt do
    local s = i * spacing
    cr:set_source(gears.color(self._private.text_color))
    cr:move_to(s, floor - 1)
    --cr:set_font_size(11)
    cr:show_text(i)
    i = i + 1
  end
end

function histogram:fit(_, width, height)
  return self._private.width, self._private.height
end

function histogram:clear()
  self._private.values = {}
  self:emit_signal("widget::redraw_needed")
  return self
end

-- Build properties function
for _, prop in ipairs(properties) do
    if not histogram["set_" .. prop] then
        histogram["set_" .. prop] = function(cx, value)
            cx._private[prop] = value
            cx:emit_signal("widget::redraw_needed")
            return cx
        end
    end
end

function histogram.new(args)
  args = args or {}

  local hist = base.make_widget(nil, nil, {
    enable_properties = true
  })

  hist._private.color            = args.color or "#fcfcfc"
  hist._private.background_color = args.background_color or "#000000" -- not used for now
  hist._private.text_color       = args.text_color or "#444444"
  hist._private.colwidth         = args.colwidth or 12
  hist._private.spacing          = args.spacing or 1
  hist._private.font             = args.font or "Sans"
  hist._private.font_size        = args.font_size or 10
  hist._private.title            = args.title or nil
  hist._private.values           = {}
  hist._private.qt               = args.qt or 1
  hist._private.width            = args.width or hist._private.qt * (hist._private.colwidth + hist._private.spacing)
  hist._private.height           = args.height or 36

  gtable.crush(hist, histogram, true)

  return hist
end

function histogram.mt:__call(...)
  return histogram.new(...)
end

return setmetatable(histogram, histogram.mt)
