Scrollable = {
	scroll_x = 0,
	scroll_y = 0,
}

function Scrollable:getScrollPos()
	return self.scroll_x, self.scroll_y
end

function Scrollable:scroll(x, y)
	if x ~= 0 and x ~= 1 and x ~= -1 then
		error("Invalid x scroll value: " .. tostring(x))
	end
	if y ~= 0 and y ~= 1 and y ~= -1 then
		error("Invalid y scroll value: " .. tostring(y))
	end

	self.scroll_x = self.scroll_x + x
	self.scroll_y = self.scroll_y + y
end

return Scrollable