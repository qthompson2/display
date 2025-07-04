OrderedContainer = require("display.ordered_container")
ElementTypes = require("display.element_types")
Style = require("display.style")

Row = {}
setmetatable(Row, {__index = OrderedContainer})

function Row:new(x, y, width, height, style)
	if not style then
		style = Style:new()
		style.horizontal_scroll = true
	end
	local obj = OrderedContainer:new(x, y, width, height, style)
	obj._rightmost_point = 0

	obj.type = ElementTypes.ROW

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Row:addChild(child)
	if #self.children > 0 then
		local previous_child = self:getChild(#self.children)
		local previous_child_right = previous_child.x + previous_child.width
		child:setPos(previous_child_right + 1, nil)
	else
		child:setPos(1, nil)
	end

	OrderedContainer.addChild(self, child)
	self._rightmost_point = child.x + child.width
end

function Row:scroll(x, _)
	if self.scroll_x > 0 and self.scroll_x < self._rightmost_point then
		Container.scroll(self, x, 0)
	end
end

return Row