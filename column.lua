OrderedContainer = require("display.ordered_container")
ElementTypes = require("display.element_types")
Style = require("display.style")

Column = {}
setmetatable(Column, {__index = OrderedContainer})

function Column:new(x, y, width, height, style)
	if not style then
		style = Style:new()
		style.vertical_scroll = true
	end
	local obj = OrderedContainer:new(x, y, width, height, style)
	obj._lowest_point = 0

	obj.type = ElementTypes.COLUMN

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Column:addChild(child)
	if #self.children > 0 then
		local previous_child = self:getChild(#self.children)
		local previous_child_bottom = previous_child.y + previous_child.height
		child:setPos(nil, previous_child_bottom)
	else
		child:setPos(nil, 1)
	end

	OrderedContainer.addChild(self, child)
	self._lowest_point = child.y + child.height
end

function Column:scroll(_, y)
	if y == 1 then
		if self.scroll_y >= 0 and self.scroll_y < self._lowest_point then
			Container.scroll(self, 0, y)
		end
	elseif y == -1 then
		if self.scroll_y > 0 and self.scroll_y <= self._lowest_point then
			Container.scroll(self, 0, y)
		end
	end
end

return Column