ElementTypes = require("elementTypes")

UpdateTargets = {
    SCREEN = "screen",
    DATA = "data"
}

Screen = {}

function Screen:new(elements, bg)
    local obj = {}
    obj.cols, obj.rows = term.getSize()
    obj.elements = elements or {}
    obj.bg = bg or colours.black
    obj.current_selection = nil

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
    for _, element in ipairs(self.elements) do
        if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW then
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

function Screen:terminate()
    term.clear()
    term.setCursorPos(1, 1)
    self.running = false
end

function Screen:handleInput()
    local eventData = {os.pullEventRaw()}
    local event = eventData[1]

    if event == "terminate" then
        self:terminate()
    elseif event == "key" then
        local key = eventData[2]
        if key == keys.tab then
            if self.current_selection then
                self.elements[self.current_selection]:clearSelection()
            end

            if self.current_selection == nil or self.current_selection >= #self.elements then
                self.current_selection = 1
            elseif self.current_selection < #self.elements then
                self.current_selection = self.current_selection + 1
            end

            if self.current_selection then
                if self.elements[self.current_selection]:getType() == ElementTypes.COLUMN or self.elements[self.current_selection]:getType() == ElementTypes.ROW then
                    self.elements[self.current_selection]:getSelectedElement():setSelected(true)
                elseif self.elements[self.current_selection]:getType() == ElementTypes.DROPDOWNMENU then
                    self.elements[self.current_selection]:setOpen(true)
                    self.elements[self.current_selection]:getSelectedElement():setSelected(true)
                end
            end
        elseif key == keys.up then
            local element = self.elements[self.current_selection]

            if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.DROPDOWNMENU then
                element:getSelectedElement():setSelected(false)
                element:scroll(-1)
                element:getSelectedElement():setSelected(true)
            end
        elseif key == keys.down then
            local element = self.elements[self.current_selection]

            if element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.DROPDOWNMENU then
                element:getSelectedElement():setSelected(false)
                element:scroll(1)
                element:getSelectedElement():setSelected(true)
            end
        elseif key == keys.enter then
            local element = self.elements[self.current_selection]

            if element then
                if element:getType() == ElementTypes.BUTTON then
                    element:getAction()()
                elseif element:getType() == ElementTypes.COLUMN or element:getType() == ElementTypes.ROW or element:getType() == ElementTypes.DROPDOWNMENU then
                    if element:getSelectedElement():getType() == ElementTypes.BUTTON then
                        element:getSelectedElement():getAction()()
                    end
                end
            end
        end
    elseif event == "mouse_click" then
        local button, x, y = eventData[2], eventData[3], eventData[4]
        local element, sub_element = self:getElementAt(x, y)

        self:clearSelection()

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
        local dir, x, y = eventData[2], eventData[3], eventData[4]

        local container_element, _ = self:getElementAt(x, y)

        self:clearSelection()

        if container_element then
            if container_element:getType() == ElementTypes.COLUMN or container_element:getType() == ElementTypes.ROW then
                container_element:scroll(dir)
            end
        end
    end
end

function Screen:run()
    self.running = true
    self.next_update_target = UpdateTargets.SCREEN
    while self.running do
        if self.next_update_target == UpdateTargets.SCREEN then
            self:draw()
            self:handleInput()
            self.next_update_target = UpdateTargets.DATA
        elseif self.next_update_target == UpdateTargets.DATA then
            --Not Implemented Yet
            self.next_update_target = UpdateTargets.SCREEN
        end
    end
end 

return Screen