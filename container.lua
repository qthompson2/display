Element = require("display.element")
ElementTypes = require("display.element_types")
Utils = require("display.utils")

Container = {}
setmetatable(Container, {__index = Element})

function Container:new(x, y, width, height, style)
	local obj = Element:new(x, y, style)

	obj.width = width or 1
	obj.height = height or 1

	obj.type = ElementTypes.CONTAINER

	obj.children = {}

	obj.scroll_x, obj.scroll_y = 0, 0

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Container:addChild(child)
	if child == nil then
		error("Child cannot be nil")
	end

	table.insert(self.children, child)
end

function Container:removeChild(index)
	if index == nil then
		error("Index cannot be nil")
	end

	if index < 1 or index > #self.children then
		error("Index out of bounds")
	end

	return table.remove(self.children, index)
end

function Container:getChild(index)
	if index == nil then
		error("Index cannot be nil")
	end

	if index < 1 or index > #self.children then
		error("Index out of bounds")
	end

	return self.children[index]
end

function Container:getChildren()
	return Utils.deepCopy(self.children)
end

function Container:isWithin(x1, y1, x2, y2)
	local cur_x, cur_y = self:getPos()
	local end_x = cur_x + self.width - 1
	local end_y = cur_y + self.height - 1

	return (x1 <= end_x and x2 >= cur_x and y1 <= end_y and y2 >= cur_y)
end 

function Container:clear(start_x, start_y, end_x, end_y)
	if self.style.hidden then
		return
	end

	local x, y = self:getPos()
	local _, bg = self:getStyleOverride():getOptions("standard")
	term.setBackgroundColour(bg)

	start_x = start_x or x
	start_y = start_y or y

	end_x = end_x or start_x + self.width - 1
	end_y = end_y or start_y + self.height - 1

	for i = start_y, math.min(y + self.height - 1, end_y) do
		for j = start_x, math.min(x + self.width - 1, end_x) do
			term.setCursorPos(j, i)
			term.write(" ")
		end
	end
end

function Container:draw(start_x, start_y, end_x, end_y)
	if self.style.hidden then
		return
	end

	self:clear(start_x, start_y, end_x, end_y)

	self:setPos(start_x, start_y)
	local x, y = self:getPos()
	start_x = start_x or x
	start_y = start_y or y
	end_x = end_x or start_x + self.width - 1
	end_y = end_y or start_y + self.height - 1

	local cur_x, cur_y = self:getScrollPos()

	for _, child in ipairs(self.children) do
		local child_x, child_y = child:getPos()

		child:setStyleOverride(self.style)
		if child:isWithin(cur_x, cur_y, math.abs(cur_x) + self.width - 1, math.abs(cur_y) + self.height - 1) then
			child:draw(
				x + child_x - 1 - cur_x,
				y + child_y - 1 - cur_y,
				x,
				y,
				math.min(end_x, start_x + self.width - 1),
				math.min(end_y, start_y + self.height - 1)
			)
		end
	end
end

function Container:scroll(x, y)
	if x ~= 0 and x ~= 1 and x ~= -1 then
		error("Invalid x scroll value: " .. tostring(x))
	end
	if y ~= 0 and y ~= 1 and y ~= -1 then
		error("Invalid y scroll value: " .. tostring(y))
	end

	self.scroll_x = self.scroll_x + x
	self.scroll_y = self.scroll_y + y
end

function Container:getScrollPos()
	return self.scroll_x, self.scroll_y
end

return Container