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
	elseif key == keys.left or key == keys.right or key == keys.up or key == keys.down then
		if screen.current_selection ~= nil then
			local selected_element = screen:getSelectableChildren()[screen.current_selection]

			if selected_element and ElementTypes.isScrollable(selected_element:getType()) then
				if key == keys.left then
					selected_element:scroll(-1, 0)
				elseif key == keys.right then
					selected_element:scroll(1, 0)
				elseif key == keys.up then
					selected_element:scroll(0, -1)
				elseif key == keys.down then
					selected_element:scroll(0, 1)
				end
			end
		end
	end
end

local function terminateListener(_, _)
	term.clear()
	term.setCursorPos(1, 1)
	term.setTextColor(colours.red)
	term.setBackgroundColor(colours.black)
	print("Terminated")
	term.setTextColor(colours.white)
end

local function mouseScrollListener(screen, event_data)
	local dir, x, y = event_data[2], event_data[3], event_data[4] -- Add functionality for selecting element with x, y when mouse functionality is implemented

	if screen.current_selection ~= nil then
		local selected_element = screen:getSelectableChildren()[screen.current_selection]

		if selected_element and ElementTypes.isScrollable(selected_element:getType()) then
			selected_element:scroll(0, dir)
		end
	end
end

return {
	["key"] = keyDownListener,
	["terminate"] = terminateListener,
	["mouse_scroll"] = mouseScrollListener,
}