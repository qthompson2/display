ElementTypes = require("display.element_types")

DEFAULT_LISTENERS = require("display.default_listeners")
TIMER_RATE = 0

Screen = {}

function Screen:new(elements, bg)
    local obj = {}
    obj.cols, obj.rows = term.getSize()
    obj.elements = elements or {}
    obj.bg = bg or colours.black
    obj.current_selection = nil
    obj.listeners = DEFAULT_LISTENERS

    obj.shift_held = false

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Screen:draw()
    term.clear()
    for i, element in ipairs(self.elements) do
        if self.current_selection == i and element ~= nil then
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

function Screen:onEventRecieved(event_data)
    local event = event_data[1]

    if self.listeners[event] then
        self.listeners[event](self, event_data)

        if event == "timer" then
            ---@diagnostic disable-next-line: undefined-field
            os.startTimer(TIMER_RATE)
        end
    end
end

function Screen:addListener(event, listener)
    self.listeners[event] = listener
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
    os.startTimer(TIMER_RATE)

    self:draw()
    while self.running do
        ---@diagnostic disable-next-line: undefined-field
        local event_data = {os.pullEventRaw()}

        self:onEventRecieved(event_data)
        if self.running then
            self:draw()
        end
    end
end

return Screen