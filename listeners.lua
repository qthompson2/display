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

	screen.current_selection = nil

	local element = screen:getElementAtPos(x, y)
	if element then
		if ElementTypes.isScrollable(element:getType()) then
			if dir == 1 then
				if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
					element:scroll(-1, 0)
				else
					element:scroll(0, -1)
				end
			elseif dir == -1 then
				if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
					element:scroll(1, 0)
				else
					element:scroll(0, 1)
				end
			end
		elseif element._parent then
			if dir == 1 then
				if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
					element._parent:scroll(-1, 0)
				else
					element._parent:scroll(0, -1)
				end
			elseif dir == -1 then
				if screen.held_keys[keys.leftShift] or screen.held_keys[keys.rightShift] then
					element._parent:scroll(1, 0)
				else
					element._parent:scroll(0, 1)
				end
			end
		end
	end
end

local function mouseClickListener(screen, event_data)
	local button, x, y = event_data[2], event_data[3], event_data[4]

	screen.current_selection = nil

	local element = screen:getElementAtPos(x, y)
	if element then
		if button == 1 then
			if element:getType() == ElementTypes.TEXT_BUTTON then
				if type(element:getAction()) == "function" then
					element:getAction()()
				end
			end
		end
	end
end

return {
	["key"] = keyDownListener,
	["terminate"] = terminateListener,
	["mouse_scroll"] = mouseScrollListener,
	["mouse_click"] = mouseClickListener,
}