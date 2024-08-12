Textbox = require("textbox")
ElementType = require("elementType")

Button = {}
setmetatable(Button, {__index = Textbox})

function Button:new(content, action, x, y, palette)
    local obj = Textbox:new(content, x, y, palette)
    obj.type = ElementType.BUTTON
    obj.action = action

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Button:getAction()
    return self.action
end

function Button:setAction(action)
    self.action = type(action) == "function" and action or error("Invalid value for action!")
end

return Button