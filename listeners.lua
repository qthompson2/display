local function keyDownListener(screen, event_data)
	local key, _ = event_data[2], event_data[3]

	if key == keys.tab then
		if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
			screen:changeSelection(-1)
		else
			screen:changeSelection(1)
		end
	end
end

return {
	["key"] = keyDownListener,
}