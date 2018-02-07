local setmetatable = setmetatable

local wrequire = function (table, key)
    local module = rawget(table, key)
    return module or require(table._NAME .. '.' .. key)
end

local widget = { _NAME = "ile.widget" }

return setmetatable(widget, { __index = wrequire })
