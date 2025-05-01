Container = require("display.container")
ElementTypes = require("display.element_types")

DropDownMenu = {}
setmetatable(DropDownMenu, {__index = Container})

function DropDownMenu:new(x, y, palette, hidden_text)
    local obj = Container:new({}, x, y, 1, palette)
    obj.type = ElementTypes.DROPDOWNMENU
    obj.open = false
    obj.open_direction = 1
    obj.hidden_text = hidden_text or "..."

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function DropDownMenu:add(element)
    if element.getType == nil then
        error("Invalid element!")
    elseif element:getType() == ElementTypes.BUTTON then
        table.insert(self.elements, element)
        self:setSize(#self.elements)
        self.max_element_length = math.max(self.max_element_length, element:len())
    else
        error("Invalid element type!")
    end
end

function DropDownMenu:addBulk(elements)
    for _, element in ipairs(elements) do
        self:add(element)
    end
end

function DropDownMenu:clearSelection()
    self:setSelected(false)
    self:setOpen(false)

    for _, element in ipairs(self.elements) do
        element:clearSelection()
    end
end

function DropDownMenu:draw(x, y)
    self:setPos(x, y)

    if self:getSelected() then
        self.palette:applySelected()
    else
        self.palette:applyStandard()
    end

    term.setCursorPos(self.x, self.y)

    if self:getOpen() then
        for i, element in ipairs(self:getElements()) do
            element:draw(self.x, self.y + ((i - 1) * self.open_direction))
        end
    else
        term.write(self.hidden_text)
    end
end

function DropDownMenu:simpleDraw(x, y, monitor)
    self:setPos(x, y)

    if self:getOpen() then
        for i, element in ipairs(self:getElements()) do
            element:simpleDraw(self.x, self.y + ((i - 1) * self.open_direction), monitor)
        end
    else
        monitor.setCursorPos(self.x, self.y)
        monitor.write(self.hidden_text)
    end
end

function DropDownMenu:setOpen(open)
    if type(open) ~= "boolean" then
        error("Invalid value for open!")
    end

    self.open = open
end

function DropDownMenu:getOpen()
    return self.open
end

function DropDownMenu:setOpenDirection(direction)
    self.open_direction = (direction == 1 or direction == -1) and direction or error("Invalid value for open direction!")
end

function DropDownMenu:getOpenDirection()
    return self.open_direction
end

function DropDownMenu:setHiddenText(text)
    self.hidden_text = text
end

function DropDownMenu:getHiddenText()
    return self.hidden_text
end

function DropDownMenu:findPos(x, y)
    if self:getOpen() then
        return x >= self.x and x <= self.x + self.max_element_length and y >= self.y and y <= self.y + self.size
    else
        return x >= self.x and x <= self.x + #self.hidden_text and y == self.y
    end
end

function DropDownMenu:getElementAt(x, y)
    local _, local_y = self:getPos()

    if self:getOpen() then
        local elements = self:getElements()

        for i, element in ipairs(elements) do
            if element:findPos(x, y) then
                return element
            end
        end
    else
        if x >= self.x and x <= self.x + #self.hidden_text and y == self.y then
            return self
        end
    end
end

function DropDownMenu:len()
    if self:getOpen() then
        return self.max_element_length
    else
        return #self.hidden_text
    end
end

return DropDownMenu