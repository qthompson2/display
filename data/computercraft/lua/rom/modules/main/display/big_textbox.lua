ElementTypes = require("display.element_types")
Element = require("display.element")
DEFAULT_CHARSET = require("display.default_charset")
COLOUR_CONVERSION_TABLE = require("display.colour_conversion_table")

BigTextbox = {}

setmetatable(BigTextbox, {__index = Element})

function BigTextbox:new(content, x, y, palette)
	local obj = Element:new(x, y, palette)
	obj.type = ElementTypes.BIGTEXTBOX
	obj.content = {
		standard = {
			[1] = "",
			[2] = "",
			[3] = "",
			[4] = "",
			[5] = "",
			[6] = "",
			[7] = "",
			[8] = "",
		},
		selected = {
			[1] = "",
			[2] = "",
			[3] = "",
			[4] = "",
			[5] = "",
			[6] = "",
			[7] = "",
			[8] = "",
		}
	}

	obj.plaintext = content

	for i = 1, #content do
		local char = content:sub(i, i)
		if DEFAULT_CHARSET[char] then
			for j = 1, 8 do
				for k = 1, #DEFAULT_CHARSET[char][j] do
					if DEFAULT_CHARSET[char][j]:sub(k, k) == "1" then
						obj.content.standard[j] = obj.content.standard[j] .. COLOUR_CONVERSION_TABLE[palette.standard.fg]
						obj.content.selected[j] = obj.content.selected[j] .. COLOUR_CONVERSION_TABLE[palette.selected.fg]
					else
						obj.content.standard[j] = obj.content.standard[j] .. COLOUR_CONVERSION_TABLE[palette.standard.bg]
						obj.content.selected[j] = obj.content.selected[j] .. COLOUR_CONVERSION_TABLE[palette.selected.bg]
					end
				end
			end
		else
			for j = 1, #DEFAULT_CHARSET.unknown do
				for k = 1, #DEFAULT_CHARSET.unknown[j] do
					if DEFAULT_CHARSET.unknown[j]:sub(k, k) == "1" then
						obj.content.standard[j] = obj.content.standard[j] .. COLOUR_CONVERSION_TABLE[palette.standard.fg]
						obj.content.selected[j] = obj.content.selected[j] .. COLOUR_CONVERSION_TABLE[palette.selected.fg]
					else
						obj.content.standard[j] = obj.content.standard[j] .. COLOUR_CONVERSION_TABLE[palette.standard.bg]
						obj.content.selected[j] = obj.content.selected[j] .. COLOUR_CONVERSION_TABLE[palette.selected.bg]
					end
				end
			end
		end
	end

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function BigTextbox:setContent(content)
	self.content = {
		standard = {
			[1] = "",
			[2] = "",
			[3] = "",
			[4] = "",
			[5] = "",
			[6] = "",
			[7] = "",
			[8] = "",
		},
		selected = {
			[1] = "",
			[2] = "",
			[3] = "",
			[4] = "",
			[5] = "",
			[6] = "",
			[7] = "",
			[8] = "",
		}
	}
	self.plaintext = content

	for i = 1, #content do
		local char = content:sub(i, i)
		if DEFAULT_CHARSET[char] then
			for j = 1, 8 do
				for k = 1, #DEFAULT_CHARSET[char][j] do
					if DEFAULT_CHARSET[char][j]:sub(k, k) == "1" then
						self.content.standard[j] = self.content.standard[j] .. COLOUR_CONVERSION_TABLE[self.palette.standard.fg]
						self.content.selected[j] = self.content.selected[j] .. COLOUR_CONVERSION_TABLE[self.palette.selected.fg]
					else
						self.content.standard[j] = self.content.standard[j] .. COLOUR_CONVERSION_TABLE[self.palette.standard.bg]
						self.content.selected[j] = self.content.selected[j] .. COLOUR_CONVERSION_TABLE[self.palette.selected.bg]
					end
				end
			end
		else
			for j = 1, #DEFAULT_CHARSET.unknown do
				for k = 1, #DEFAULT_CHARSET.unknown[j] do
					if DEFAULT_CHARSET.unknown[j]:sub(k, k) == "1" then
						self.content.standard[j] = self.content.standard[j] .. COLOUR_CONVERSION_TABLE[self.palette.standard.fg]
						self.content.selected[j] = self.content.selected[j] .. COLOUR_CONVERSION_TABLE[self.palette.selected.fg]
					else
						self.content.standard[j] = self.content.standard[j] .. COLOUR_CONVERSION_TABLE[self.palette.standard.bg]
						self.content.selected[j] = self.content.selected[j] .. COLOUR_CONVERSION_TABLE[self.palette.selected.bg]
					end
				end
			end
		end
	end
end

function BigTextbox:getContent()
	return self.plaintext
end

function BigTextbox:draw()
	for i = 1, #self.content.standard do
		local blank_line = (" "):rep(#self.content.standard[i])
		term.setCursorPos(self.x, self.y + i - 1)
		if self.selected then
			term.blit(blank_line, blank_line, self.content.selected[i])
		else
			term.blit(blank_line, blank_line, self.content.standard[i])
		end
	end
end

function BigTextbox:len()
	return #self.content.standard[1]
end

function BigTextbox:findPos(x, y)
	if x >= self.x and x <= self.x + #self.content.standard[1] - 1 and y >= self.y and y <= self.y + #self.content.standard - 1 then
		return true
	else
		return false
	end
end

return BigTextbox