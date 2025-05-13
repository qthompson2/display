Element = require("display.element")
ElementTypes = require("display.element_types")
Utils = require("display.utils")

Textbox = {}
setmetatable(Textbox, {__index = Element})

function Textbox:new(text, x, y, width, height, style)
	local obj = Element:new(x, y, style)

	obj.width = width or 1
	obj.height = height or 1

	obj.type = ElementTypes.TEXTBOX

	obj.text = text or ""

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Textbox:draw(x, y, start_x, start_y, end_x, end_y)
	if self.style.hidden then
		return
	end

	self:setPos(x, y)
	x, y = self:getPos()

	local fg, bg = self:getStyleOverride()

	local lines = Utils.split(self.text, "\n")

	for i = 1, #lines do
		local line = lines[i]
		
	end
end