Style = {}

function Style:new(options)
	options = {
		text = options.text or colours.white,
		text_selected = options.text_selected or colours.black,
		text_disabled = options.text_disabled or colours.gray,

		background = options.background or colours.black,
		background_selected = options.background_selected or colours.yellow,
		background_disabled = options.background_disabled or colours.black,

		hidden = options.hidden or false,

		horizontal_scroll = options.horizontal_scroll or true,
		vertical_scroll = options.vertical_scroll or true,
	}

	local obj = {}

	obj.options = options

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Style:getOptions(type)
	if self.options.hidden then
		return nil, nil
	else
		if type == nil or type == "standard" then
			return self.options.text, self.options.background
		elseif type == "selected" then
			return self.options.text_selected, self.options.background_selected
		elseif type == "disabled" then
			return self.options.text_disabled, self.options.background_disabled
		else
			error("Invalid type: " .. tostring(type))
		end
	end
end

function Style:setOptions(options)
	self.options = {
		text = options.text or self.options.text,
		text_selected = options.text_selected or self.options.text_selected,
		text_disabled = options.text_disabled or self.options.text_disabled,

		background = options.background or self.options.background,
		background_selected = options.background_selected or self.options.background_selected,
		background_disabled = options.background_disabled or self.options.background_disabled,

		hidden = options.hidden or self.options.hidden,
	}
end

return Style