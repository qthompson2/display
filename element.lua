ElementType = {
    TEXTBOX = 1,
    BUTTON = 2,
    ROW = 3,
    COLUMN = 4
}

Element = {}

function Element:new(x, y, palette, type)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.palette = palette
    obj.type = type

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

return Element