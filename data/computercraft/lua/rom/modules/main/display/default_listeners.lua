ElementTypes = require("display.element_types")

return {
	["key"] = function(self, event_data)
		local key = event_data[2]

        if key == keys.tab then
            if self.current_selection then
                self.elements[self.current_selection]:clearSelection()
            end

            if self.current_selection == nil then
                if self.shift_held then
                    self.current_selection = #self.elements
                else
                    self.current_selection = 1
                end
            elseif self.current_selection >= #self.elements then
                if self.shift_held then
                    self.current_selection = self.current_selection - 1
                else
                    self.current_selection = 1
                end
            elseif self.current_selection <= 1 then
                if self.shift_held then
                    self.current_selection = #self.elements
                else
                    self.current_selection = self.current_selection + 1
                end
            elseif self.current_selection < #self.elements then
                if self.shift_held then
                    self.current_selection = self.current_selection - 1
                else
                    self.current_selection = self.current_selection + 1
                end
            end

            if self.current_selection then
                if self.elements[self.current_selection]:getType() == ElementTypes.COLUMN or self.elements[self.current_selection]:getType() == ElementTypes.ROW or self.elements[self.current_selection]:getType() == ElementTypes.BUNDLE then
                    self.elements[self.current_selection]:getSelectedElement():setSelected(true)
                elseif self.elements[self.current_selection]:getType() == ElementTypes.DROPDOWNMENU then
                    self.elements[self.current_selection]:setOpen(true)
                    self.elements[self.current_selection]:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.up then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.DROPDOWNMENU then
                    element:getSelectedElement():setSelected(false)
                    element:scroll(-1)
                    element:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.down then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.DROPDOWNMENU then
                    element:getSelectedElement():setSelected(false)
                    element:scroll(1)
                    element:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.enter then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.BUTTON then
                    element:getAction()()
                elseif element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.DROPDOWNMENU or element:getType() == ElementTypes.BUNDLE then
                    if element:getSelectedElement():getType() == ElementTypes.BUTTON then
                        element:getSelectedElement():getAction()()
                    end
                end
            end
        elseif key == keys.backspace then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.TEXTFIELD then
                    element:backspace()
                elseif element:getType() == ElementTypes.BUNDLE then
                    if element:getSelectedElement():getType() == ElementTypes.TEXTFIELD then
                        element:getSelectedElement():backspace()
                    end
                end
            end
        elseif key == keys.left then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.TEXTFIELD then
                    element:scroll(-1)
                elseif element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.BUNDLE then
                    element:getSelectedElement():setSelected(false)
                    element:scroll(-1)
                    element:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.right then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.TEXTFIELD then
                    element:scroll(1)
                elseif element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.BUNDLE then
                    element:getSelectedElement():setSelected(false)
                    element:scroll(1)
                    element:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.leftShift or key == keys.rightShift then
            self.shift_held = true
        end
	end,

	["terminate"] = function(self, _)
		term.setBackgroundColour(colours.black)
    	term.clear()
    	term.setCursorPos(1, 1)
    	self.running = false
	end,

	["char"] = function(self, event_data)
		local char = event_data[2]
        local element = self.elements[self.current_selection]

        if element then
            if element:getType() == ElementTypes.TEXTFIELD then
                element:appendInput(char)
            elseif element:getType() == ElementTypes.BUNDLE then
                if element:getSelectedElement():getType() == ElementTypes.TEXTFIELD then
                    element:getSelectedElement():appendInput(char)
                end
            end
        end
	end,

	["mouse_click"] = function(self, event_data)
		local button, x, y = event_data[2], event_data[3], event_data[4]
        local element, sub_element = self:getElementAt(x, y)

        self:clearSelection()

        if element then
            element:setSelected(true)
            self.current_selection = self:getIndex(element)
        end
        if sub_element then
            sub_element:setSelected(true)
            self.current_selection = self:getIndex(element)
        end

        if element and button == 1 then
            if element:getType() == ElementTypes.BUTTON then
                element:getAction()()
            elseif sub_element then
                if sub_element:getType() == ElementTypes.BUTTON then
                    sub_element:getAction()()
                end
            end
        end

        if element and button == 2 then
            if element:getType() == ElementTypes.DROPDOWNMENU then
                element:setOpen(not element:getOpen())
            elseif sub_element then
                if sub_element:getType() == ElementTypes.DROPDOWNMENU then
                    sub_element:setOpen(not sub_element:getOpen())
                end
            end
        end
	end,

	["mouse_scroll"] = function(self, event_data)
		local dir, x, y = event_data[2], event_data[3], event_data[4]

        local container_element, _ = self:getElementAt(x, y)

        self:clearSelection()

        if container_element then
            if container_element:getType() == ElementTypes.COLUMN or container_element:getType() == ElementTypes.ROW then
                container_element:scroll(dir, true)
            end
        end
	end,

	["key_up"] = function(self, event_data)
		local key = event_data[2]

        if key == keys.leftShift or key == keys.rightShift then
            self.shift_held = false
        end
	end
}