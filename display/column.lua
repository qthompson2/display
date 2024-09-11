ElementTypes = require("display.element_types")
Container = require("display.container")

Column = {}
setmetatable(Column, {__index = Container})

function Column:new(x, y, size, palette)
    local obj = Container:new({}, x, y, size, palette)
    obj.type = ElementTypes.COLUMN

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Column:draw(x, y)
    self:setPos(x, y)

    if self:getSelected() then
        self.palette:applySelected()
    else
        self.palette:applyStandard()
    end

    for i = 1, self:getSize() do
        term.setCursorPos(self.x, self.y + i - 1)
        term.write("\149")
    end

    for i, element in ipairs(self:getVisibleElements()) do
        element:draw(self.x + 1, self.y + i - 1)
    end
end

function Column:findPos(x, y)
    return x >= self.x and x <= self.x + self.max_element_length and y >= self.y and y <= self.y + self.size
end

function Column:getElementAt(x, y)
    local _, local_y = self:getPos()

    local elements = self:getVisibleElements()

    if elements[y - local_y + 1] and elements[y - local_y + 1]:findPos(x, y) then
        return elements[y - local_y + 1]
    end
end

function Column:len()
    return self.max_element_length
end

return Column