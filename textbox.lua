Element = require("bin.display.element")
ElementTypes = require("bin.display.element_types")
Utils = require("bin.display.utils")
Output = require("bin.cc-output")

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

function Textbox:draw(x, y, start_x, start_y, end_x, end_y)
	if self.style.hidden then
		return
	end

	local original_x, original_y = self:getPos()

	self:setPos(x, y)
	x, y = self:getPos()

	local fg, bg = self:getStyleOverride():getOptions("standard")
	if self.disabled then
		fg, bg = self:getStyleOverride():getOptions("disabled")
	elseif self.selected then
		fg, bg = self:getStyleOverride():getOptions("selected")
	end

	local lines = Utils.wrap(self.text, self.width)

	start_x = start_x or x
	start_y = start_y or y
	end_x = end_x or x + self.width - 1
	end_y = end_y or y + self.height - 1


	Output.setTextColor(fg)
	Output.setBackgroundColor(bg)
	for i = 1, #lines do
		local line = lines[i]

		for j = 1, #line do
			local char = line:sub(j, j)

			local char_x, char_y = x + j - 1, y + i - 1

			if (char_x <= end_x and char_x >= start_x and char_y <= end_y and char_y >= start_y) then
				Output.setCursorPos(char_x, char_y)
				Output.write(char)
			end
		end
	end

	self:setPos(original_x, original_y)
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