ElementType = require("elementType")

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

function Screen:getElementAt(x, y)
    for _, element in ipairs(self.elements) do
        if element:getType() == ElementType.COLUMN or element:getType() == ElementType.ROW then
            local sub_element = element:getElementAt(x, y)

            if sub_element ~= nil then
                return element, sub_element
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
            local button, x, y = eventData[2], eventData[3], eventData[4]
            local element, sub_element = self:getElementAt(x, y)

            if element then
                if element:getType() == ElementType.BUTTON then
                    element:getAction()()
                elseif sub_element then
                    if sub_element:getType() == ElementType.BUTTON then
                        sub_element:getAction()()
                    end
                end
            end
        elseif event == "mouse_scroll" then
            local dir, x, y = eventData[2], eventData[3], eventData[4]

            local container_element, _ = self:getElementAt(x, y)

            if container_element then
                if container_element:getType() == ElementType.COLUMN or container_element:getType() == ElementType.ROW then
                    container_element:scroll(dir)
                end
            end
        end
    end
end 

return Screen