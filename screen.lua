Screen = {}

function Screen:new(elements)
    local obj = {}
    obj.width, obj.length = term.getSize()
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

function Screen:findPos(x, y)
    for i, element in ipairs(self.elements) do
        local x1, y1, x2, _ = element:getArea()
        if x >= x1 and x <= x2 and y == y1 then
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
            local _, element = self:findPos(x, y)
            if element then
                if element.action then
                    element.action()
                end
            end
        end
    end
end

return Screen