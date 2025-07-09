Element = require("display.element")
ElementTypes = require("display.element_types")
Utils = require("display.utils")
Output = require("cc-output")

Textbox = {}
setmetatable(Textbox, {__index = Element})

function Textbox:new(text, x, y, width, height, style)
	local obj = Element:new(x, y, style)

	text = text or ""

	obj.width = width or #text
	obj.height = height or 1

	obj.type = ElementTypes.TEXT_BOX

	obj.text = text

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Textbox:draw()
	if self.style.hidden then
		return
	end

	self:clear()

	local lines = Utils.wrap(self.text, self.width)
	for i, line in ipairs(lines) do
		if i <= self.height then
			self._window.setCursorPos(1, i)
			self._window.write(line)
		else
			break
		end
	end
end

function Textbox:isWithin(x1, y1, x2, y2)
	local cur_x, cur_y = self:getPos()
	local end_x = cur_x + self.width - 1
	local end_y = cur_y + self.height - 1

	return (x1 <= end_x and x2 >= cur_x and y1 <= end_y and y2 >= cur_y)
end

function Textbox:getText()
	return self.text
end

function Textbox:setText(text)
	self.text = text or self.text
end

return Textbox