ElementTypes = require("display.element_types")

Screen = {}

function Screen:new(elements, bg)
    local obj = {}
    obj.cols, obj.rows = term.getSize()
    obj.elements = elements or {}
    obj.bg = bg or colours.black
    obj.current_selection = nil
    obj.data_functions = {}

    obj.shift_held = false

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Screen:draw()
    term.clear()
    for i, element in ipairs(self.elements) do
        if self.current_selection == i then
            element:setSelected(true)
        else
            element:setSelected(false)
        end

        element:draw()
        term.setBackgroundColor(self.bg)
    end
end

function Screen:clearSelection()
    self.current_selection = nil
    for _, element in ipairs(self.elements) do
        element:clearSelection()
    end
end

function Screen:getElementAt(x, y)
    for i = #self.elements, 1, -1 do
        local element = self.elements[i]
        if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.BUNDLE then
            local sub_element = element:getElementAt(x, y)

            if sub_element ~= nil then
                return element, sub_element
            end
        elseif element:getType() == ElementTypes.DROPDOWNMENU then
            if element:getOpen() then
                local sub_element = element:getElementAt(x, y)

                if sub_element ~= nil then
                    return element, sub_element
                end
            else
                if element:findPos(x, y) then
                    return element, nil
                end
            end
        elseif element:findPos(x, y) then
            return element, nil
        end
    end
end

function Screen:add(element)
    table.insert(self.elements, element)
end

function Screen:addBulk(elements)
    for _, element in ipairs(elements) do
        table.insert(self.elements, element)
    end
end

function Screen:remove(element)
    if tonumber(element) then
        return table.remove(self.elements, element)
    else
        for i, e in ipairs(self.elements) do
            if e == element then
                return table.remove(self.elements, i)
            end
        end
    end
end

function Screen:getIndex(element)
    for i, e in ipairs(self.elements) do
        if e == element then
            return i
        end
    end
end

function Screen:terminate()
    term.setBackgroundColour(colours.black)
    term.clear()
    term.setCursorPos(1, 1)
    self.running = false
end

function Screen:terminateAll()
    error("I don't know how to implement this rn")
end

function Screen:onEventRecieved(event_data)
    local event = event_data[1]

    if event == "terminate" then
        self:terminate()
    elseif event == "key" then
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
    elseif event == "char" then
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
    elseif event == "mouse_click" then
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

    elseif event == "mouse_scroll" then
        local dir, x, y = event_data[2], event_data[3], event_data[4]

        local container_element, _ = self:getElementAt(x, y)

        self:clearSelection()

        if container_element then
            if container_element:getType() == ElementTypes.COLUMN or container_element:getType() == ElementTypes.ROW then
                container_element:scroll(dir)
            end
        end
    elseif event == "key_up" then
        local key = event_data[2]

        if key == keys.leftShift or key == keys.rightShift then
            self.shift_held = false
        end
    elseif event == "modem_message" then
        if self.onModemMessageReceived then
            self.onModemMessageReceived(event_data)
        end
    end
end

function Screen:handleData()
    for _, data_function in ipairs(self.data_functions) do
        data_function(self)
    end
end

function Screen:addDataFunction(data_function)
    table.insert(self.data_functions, data_function)
end

function Screen:addListener(event, listener) --Change this to be better
    if event == "modem_message" then
        self.onModemMessageReceived = listener
    end
end

function Screen:removeDataFunction(data_function)
    for i, l in ipairs(self.data_functions) do
        if l == data_function then
            table.remove(self.data_functions, i)
        end
    end
end

function Screen:run()
    term.setBackgroundColour(self.bg)
    term.clear()
    self.running = true
    ---@diagnostic disable-next-line: undefined-field
    os.startTimer(1)

    self:draw()
    while self.running do
        ---@diagnostic disable-next-line: undefined-field
        local event_data = {os.pullEventRaw()}
        local event = event_data[1]

        if event ~= "timer" then
            self:draw()
            self:onEventRecieved(event_data)
        elseif event == "timer" then
            self:handleData()
            ---@diagnostic disable-next-line: undefined-field
            os.startTimer(1)
        end
    end
end

return Screen