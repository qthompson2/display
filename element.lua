ElementTypes = require("element_types")
Style = require("style")

Element = {}

function Element:new(x, y, style)
	local obj = {}

	obj.x = x or 1
	obj.y = y or 1

	obj.style = style or Style:new()
	if style ~= nil then
		obj.allow_style_override = false
	else
		obj.allow_style_override = true
	end
	obj.style_override = nil

	obj.type = ElementTypes.ELEMENT

	obj.disabled = false

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Element:draw(start_x, start_y, end_x, end_y)
	error("Element:draw() must be overridden in subclasses!")
end

function Element:isWithin(x1, y1, x2, y2)
	error("Element:isWithin() must be overridden in subclasses!")
end

function Element:getDimensions()
	if self.width == nil or self.height == nil then
		error("Element:getDimensions() must be overridden in subclasses!")
	end
	return self.x, self.y, self.x + self.width - 1, self.y + self.height - 1
end

function Element:getPos()
	return self.x, self.y
end

function Element:setPos(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Element:getStyle()
	return self.style
end

function Element:setStyle(style)
	self.style = style or self.style
end

function Element:getStyleOverride()
	if self.allow_style_override then
		return self.style_override
	else
		return self.style
	end
end

function Element:setStyleOverride(style)
	if self.allow_style_override then
		self.style_override = style or self.style_override
	end
end

function Element:getType()
	return self.type
end

return Element