local function keyDownListener(screen, event_data)
	local key, _ = event_data[2], event_data[3]

	if key == keys.tab then
		if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
			screen:changeSelection(-1)
		else
			screen:changeSelection(1)
		end
	elseif key == keys.enter then
		local selectable_elements = screen:getSelectableChildren()

		if #selectable_elements > 0 then
			local selected_element = selectable_elements[screen.current_selection]
			if selected_element then
				if selected_element:getType() == ElementTypes.TEXT_BUTTON then
					if type(selected_element:getAction()) == "function" then
						selected_element:getAction()()
					end
				end
			end
		end
	end
end

return {
	["key"] = keyDownListener,
}