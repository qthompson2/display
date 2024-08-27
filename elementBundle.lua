ElementTypes = require("elementTypes")
Container = require("container")

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

    if self:getSelected() then
        self.palette:applySelected()
    else
        self.palette:applyStandard()
    end

    term.setCursorPos(self.x, self.y)

    for i, element in ipairs(self:getElements()) do
        if i ~= 1 then
            element:draw(self.x + self:getElements()[i - 1]:len() + 1, self.y)
        else
            element:draw(self.x, self.y)
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

return ElementBundle