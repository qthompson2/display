Output = require("cc-output")
ElementTypes = require("display.element_types")
Style = require("display.style")

Element = {}

function Element:new(x, y, width, height, style)
	local obj = {}

	obj.x = x or 1
	obj.y = y or 1
	obj.width = width or 1
	obj.height = height or 1

	obj._window = window.create(Output, obj.x, obj.y, obj.width, obj.height, true)

	obj.style = style or Style:new()
	if style ~= nil then
		obj.allow_style_override = false
	else
		obj.allow_style_override = true
	end
	obj.style_override = nil

	obj.type = ElementTypes.ELEMENT

	obj.disabled = false
	obj.selected = false

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Element:draw()
	error("Element:draw() must be overridden in subclasses!")
end

function Element:isWithin(x1, y1, x2, y2)
	error("Element:isWithin() must be overridden in subclasses!")
end

function Element:clear()
	if self._window then
		local style = self:getStyleOverride()

		local fg, bg = style:getOptions("standard")
		if self.disabled then
			fg, bg = style:getOptions("disabled")
		elseif self.selected then
			fg, bg = style:getOptions("selected")
		end

		self._window.setTextColour(fg)
		self._window.setBackgroundColour(bg)
		self._window.clear()
	end
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
		return self.style_override or self.style
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

function Element:getSelected()
	return self.selected
end

function Element:setSelected(selected)
	if type(selected) ~= "boolean" then
		error("Element:setSelected() expects a boolean value.")
	end

	self.selected = selected
end

return Element