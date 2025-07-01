Textbox = require("display.textbox")
ElementTypes = require("display.element_types")

TextButton = {}
setmetatable(TextButton, {__index = Textbox})

function TextButton:new(text, x, y, width, height, style)
	local obj = Textbox:new(text, x, y, width, height, style)

	obj.type = ElementTypes.TEXT_BUTTON
	obj.action = nil  -- Placeholder for action to be set later

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function TextButton:setAction(action)
	if type(action) ~= "function" then
		error("Action must be a function")
	end

	self.action = action
end

function TextButton:getAction()
	return self.action
end

return TextButton