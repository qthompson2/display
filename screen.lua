Screen = {}

function Screen:new(elements)
    local obj = {}
    obj.cols, obj.rows = term.getSize()
    obj.elements = elements or {}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Screen:draw()
    term.clear()
    for i, element in ipairs(self.elements) do
        element:draw()
    end
end

function Screen:findPos(x, y, mode)
    for i, element in ipairs(self.elements) do
        if element:findPos(x, y) and mode == "recursive" then
            element:select()
            return i, element:findPos(x, y)
        elseif element:findPos(x, y) then
            element:select()
            return i, element
        end
    end
    return nil
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

function Screen:terminate()
    term.clear()
    term.setCursorPos(1, 1)
    self.running = false
end

function Screen:run()
    self.running = true
    while self.running do
        self:draw()
        local eventData = {os.pullEventRaw()}
        local event = eventData[1]

        if event == "terminate" then
            self:terminate()
        elseif event == "mouse_click" then
            local x, y = eventData[3], eventData[4]
            local _, element = self:findPos(x, y, "recursive")
            if element then
                if element.action then
                    element:click()
                end
            end
        elseif event == "mouse_scroll" then
            local dir, x, y = eventData[2], eventData[3], eventData[4]
            local _, element = self:findPos(x, y)
            if element and element.scrollDown then
                if dir == -1 then
                    element:scrollUp()
                else
                    element:scrollDown()
                end
            end
        end
    end
end

return Screen