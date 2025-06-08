SELECTABLE = {
	[0] = false, -- SCREEN
	[1] = false, -- ELEMENT
	[2] = false, -- TEXT_BOX
	[3] = true, -- TEXT_BUTTON
	[4] = true, -- TEXT_INPUT
	[5] = false, -- IMAGE
	[6] = false, -- BIG_TEXT_BOX
	[7] = true, -- CONTAINER
	[8] = true, -- ORDERED_CONTAINER
	[9] = true, -- ROW
	[10] = true, -- COLUMN
}

local function isSelectable(element_type)
	local res = SELECTABLE[element_type]
	if res == nil then
		error("Invalid element type: " .. element_type)
	end

	return res
end

return {
	SCREEN = 0,
	ELEMENT = 1,
	TEXT_BOX = 2,
	TEXT_BUTTON = 3,
	TEXT_INPUT = 4,
	IMAGE = 5,
	BIG_TEXT_BOX = 6,
	CONTAINER = 7,
	ORDERED_CONTAINER = 8,
	ROW = 9,
	COLUMN = 10,
	isSelectable = isSelectable
}