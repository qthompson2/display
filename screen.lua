ElementTypes = require("display.element_types")

DEFAULT_LISTENERS = require("display.default_listeners")
TIMER_RATE = 0

Utils = require("display.utils")

Screen = {}

function Screen:new(elements, bg)
    local obj = {}
    obj.cols, obj.rows = term.getSize()
    obj.elements = elements or {}
    obj.bg = bg or colours.black
    obj.current_selection = nil

    obj.listeners = Utils.deepCopy(DEFAULT_LISTENERS)

    obj.shift_held = false

    local native_monitor = term.native()
    native_monitor.type = "monitor"

    obj.monitors = {
        ["native"] = native_monitor
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Screen:draw()
    for _, monitor in pairs(self.monitors) do
        term.redirect(monitor)

        if monitor.type == "monitor" then
            monitor.setBackgroundColour(self.bg)
            monitor.setTextColour(colours.white)
        end
        
        term.clear()
        term.setCursorPos(1, 1)
    end

    for i, element in ipairs(self.elements) do
        if self.current_selection == i and element ~= nil then
            element:setSelected(true)
        else
            element:setSelected(false)
        end

        for _, monitor in pairs(self.monitors) do
            if monitor.type == "monitor" then
                term.redirect(monitor)
                element:draw()
                term.redirect(term.native())
            elseif monitor.type == "Create_DisplayLink" then
                element:simpleDraw(nil, nil, monitor)
                monitor.update()
            end
        end
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

function Screen:connectMonitor(monitor_name)
    local monitor = peripheral.wrap(monitor_name)
    if monitor then
        monitor.type = peripheral.getType(monitor_name)

        if monitor.type == "monitor" then
            monitor.setBackgroundColour(colours.black)
            monitor.setTextColour(colours.white)
        end

        monitor.clear()
        monitor.setCursorPos(1, 1)

        if monitor.type == "Create_DisplayLink" then
            monitor.update()
        end

        self.monitors[monitor_name] = monitor
    end
end

function Screen:disconnectMonitor(monitor_name)
    if self.monitors[monitor_name] then
        local monitor = self.monitors[monitor_name]
        term.redirect(monitor)
        self.monitors[monitor_name] = nil

        if monitor.type == "monitor" then
            monitor.setBackgroundColour(colours.black)
            monitor.setTextColour(colours.white)
        end

        term.clear()
        term.setCursorPos(1, 1)

        if monitor.type == "Create_DisplayLink" then
            monitor.update()
        end

        term.redirect(term.native())

        return monitor
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
    local monitor = next(self.monitors)
    while monitor do
        monitor = next(self.monitors)
        self:disconnectMonitor(monitor)
    end

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

function Screen:getListener(event)
    return self.listeners[event]
end

function Screen:setListener(event, listener)
    self.listeners[event] = listener
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