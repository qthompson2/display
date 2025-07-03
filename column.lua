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

	obj.type = ElementTypes.COLUMN

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Column:addChild(child)
	if #self.children > 0 then
		local previous_child = self:getChild(#self.children)
		local previous_child_bottom = previous_child.y + previous_child.height
		child:setPos(nil, previous_child_bottom + 1)
	else
		child:setPos(nil, 1)
	end

	OrderedContainer.addChild(self, child)
end

function Column:scroll(_, y)
	Container.scroll(self, 0, y)
end

return Column