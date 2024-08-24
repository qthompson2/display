Element = {}

function Element:new(x, y, palette)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.palette = palette
    obj.type = nil
    obj.selected = false

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Element:getPos()
    return self.x, self.y
end

function Element:setPos(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function Element:findPos(x, y)
    error("Element:findPos() must be implemented in child classes!")
end

function Element:draw(x, y)
    error("Element:draw() must be implemented in child classes!")
end

function Element:getPalette()
    return self.palette
end

function Element:setPalette(palette)
    self.palette = palette
end

function Element:getType()
    return self.type
end

function Element:getSelected()
    return self.selected
end

function Element:setSelected(selected)
    if type(selected) ~= "boolean" then
        error("Invalid value for selected!")
    end

    self.selected = selected
end

function Element:clearSelection()
    self.selected = false
end

return Element