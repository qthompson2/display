Element = require("display.element")
ElementTypes = require("display.element_types")

Image = {}
setmetatable(Image, {__index = Element})

function Image:new(image_path_or_image, x, y)
	local obj = Element:new(x, y, nil)

	obj.image = {}
	obj.length = 0

	if type(image_path_or_image) == "string" then
		local image_file = fs.open(image_path_or_image, "r")
		if not image_file then
			error("Invalid image path: " .. image_path_or_image)
		end
		while true do
			local line = image_file.readLine()
			if not line then break end
			if #line > obj.length then
				obj.length = #line
			end
			table.insert(obj.image, line)
		end
	elseif type(image_path_or_image) == "table" then
		if #image_path_or_image == 0 then
			error("Invalid image table: empty table")
		end
		for _, line in ipairs(image_path_or_image) do
			if #line > obj.length then
				obj.length = #line
			end
		end
		obj.image = image_path_or_image
	else
		error("Invalid image type: " .. type(image_path_or_image))
	end

	obj.type = ElementTypes.IMAGE

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Image:draw()
	for i = 1, #self.image do
		local blank_line = (" "):rep(#self.image[i])
		term.setCursorPos(self.x, self.y + i - 1)
		term.blit(blank_line, blank_line, self.image[i])
	end
end

function Image:setImage(image)
	if type(image) == "string" then
		local image_file = fs.open(image, "r")
		if not image_file then
			error("Invalid image path: " .. image)
		end
		self.image = {}
		while true do
			local line = image_file.readLine()
			if not line then break end
			table.insert(self.image, line)
		end
	elseif type(image) == "table" then
		if #image == 0 then
			error("Invalid image table: empty table")
		end
		for _, line in ipairs(image) do
			if #line > self.length then
				self.length = #line
			end
		end
		self.image = image
	else
		error("Invalid image type: " .. type(image))
	end

	self.length = 0
	for _, line in ipairs(self.image) do
		if #line > self.length then
			self.length = #line
		end
	end
end

function Image:getImage()
	return self.image
end

function Image:len()
	return self.length
end

function Image:findPos(x, y)
	if x >= self.x and x <= self.x + self.length - 1 and y >= self.y and y <= self.y + #self.image - 1 then
		return true
	else
		return false
	end
end

return Image