Element = require("bin.display.element")
ElementTypes = require("bin.display.element_types")
Utils = require("bin.display.utils")
Output = require("bin.cc-output")

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
	return self.children
end

function Container:getSelectableChildren()
	local selectable_children = {}
	for _, child in ipairs(self.children) do
		if ElementTypes.isSelectable(child:getType()) then
			table.insert(selectable_children, child)

			if type(child.getSelectableChildren) == "function" then
				local selectable_children_of_child = child:getSelectableChildren()

				for _, sub_child in ipairs(selectable_children_of_child) do
					table.insert(selectable_children, sub_child)
				end
			end
		end
	end

	return selectable_children
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
	if self.disabled then
		_, bg = self:getStyleOverride():getOptions("disabled")
	elseif self.selected then
		_, bg = self:getStyleOverride():getOptions("selected")
	end

	Output.setBackgroundColour(bg)

	start_x = start_x or x
	start_y = start_y or y

	end_x = end_x or start_x + self.width - 1
	end_y = end_y or start_y + self.height - 1

	for i = start_y, math.min(y + self.height - 1, end_y) do
		for j = start_x, math.min(x + self.width - 1, end_x) do
			Output.setCursorPos(j, i)
			Output.write(" ")
		end
	end
end

function Container:draw(x, y, start_x, start_y, end_x, end_y)
	if self.style.hidden then
		return
	end

	local original_x, original_y = self:getPos()

	self:clear(x, y, end_x, end_y)

	self:setPos(x, y)
	x, y = self:getPos()
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
				math.min(end_x, x + self.width - 1),
				math.min(end_y, y + self.height - 1)
			)
		end
	end

	self:setPos(original_x, original_y)
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

function Container:setSelected(selected)
	if type(selected) ~= "boolean" then
		error("Container:setSelected() expects a boolean value.")
	end

	self.selected = selected

	for _, child in ipairs(self.children) do
		child:setSelected(selected)
	end
end

return Container