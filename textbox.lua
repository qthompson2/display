Element = require("element")
ElementTypes = require("elementTypes")

Textbox = {}
setmetatable(Textbox, {__index = Element})

function Textbox:new(content, x, y, palette)
    local obj = Element:new(x, y, palette)
    obj.type = ElementTypes.TEXTBOX
    obj.content = content

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Textbox:getContent()
    return self.content
end

function Textbox:setContent(content)
    self.content = tostring(content) ~= nil and content or error("Invalid value for content!")
end

function Textbox:findPos(x, y)
    return x >= self.x and x <= self.x + #self.content and y == self.y
end

function Textbox:draw(x, y)
    self:setPos(x, y)

    if self:getSelected() then
        self.palette:applySelected()
    else
        self.palette:applyStandard()
    end

    term.setCursorPos(self.x, self.y)
    term.write(self.content)
end

function Textbox:len()
    return #self.content
end

return Textbox