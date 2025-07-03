Container = require("display.container")

OrderedContainer = {}
setmetatable(OrderedContainer, {__index = Container})

function OrderedContainer:new(x, y, width, height, style)
	local obj = Container:new(x, y, width, height, style)

	obj.type = ElementTypes.ORDERED_CONTAINER

	setmetatable(obj, self)
	self.__index = self

	return obj
end

return OrderedContainer