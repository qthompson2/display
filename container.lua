Element = require("display.element")
ElementTypes = require("display.element_types")
Utils = require("display.utils")
Output = require("cc-output")

Container = {}
setmetatable(Container, {__index = Element})

function Container:new(x, y, width, height, style)
	local obj = Element:new(x, y, width, height, style)

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

function Container:draw()
	if self.style.hidden then
		return
	end

	self:clear()
	for _, child in ipairs(self.children) do
		local child_x, child_y = child:getPos()
		child:setStyleOverride(self.style)
		child._window.reposition(child_x - self.scroll_x, child_y - self.scroll_y, child.width, child.height, self._window)
		child._parent = self
		child:draw()
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

function Container:setSelected(selected)
	if type(selected) ~= "boolean" then
		error("Container:setSelected() expects a boolean value.")
	end

	self.selected = selected

	for _, child in ipairs(self.children) do
		child:setSelected(selected)
	end
end

function Container:panToCoordinate(x, y)
	self.scroll_x = x - 1
	self.scroll_y = y - 1
end

return Container