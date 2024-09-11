ElementTypes = require("display.element_types")
Container = require("display.container")

ElementBundle = {}
setmetatable(ElementBundle, {__index = Container})

function ElementBundle:new(x, y, palette)
    local obj = Container:new({}, x, y, 1, palette)
    obj.type = ElementTypes.BUNDLE

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function ElementBundle:draw(x, y)
    self:setPos(x, y)

    term.setCursorPos(self.x, self.y)

    for i, element in ipairs(self:getElements()) do
        if i == 1 then
            element:draw(self.x, self.y)
        else
            local cursor_x, _ = term.getCursorPos()
            element:draw(cursor_x + 1, self.y)
        end
    end
end

function ElementBundle:len()
    local len = 0
    for _, element in ipairs(self:getElements()) do
        len = len + element:len() + 1
    end
    return len - 1
end

function ElementBundle:findPos(x, y)
    for _, element in ipairs(self:getElements()) do
        if element:findPos(x, y) then
            return true
        end
    end
    return false
end

function ElementBundle:getElementAt(x, y)
    for _, element in ipairs(self:getElements()) do
        if element:findPos(x, y) then
            return element
        end
    end
    return nil
end

return ElementBundle