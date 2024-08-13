Element = require("element")

Container = {}
setmetatable(Container, {__index = Element})

function Container:new(elements, x, y, size, palette)
    local obj = Element:new(x, y, palette)
    obj.elements = elements
    obj.current_selection = 1
    obj.start_index = 1
    obj.size = size

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Container:add(element)
    if element.getType == nil then
        error("Invalid element!")
    elseif element:getType() == ElementType.Button or element:getType() == ElementType.Textbox then
        table.insert(self.elements, element)
    else
        error("Invalid element type!")
    end
end

function Container:remove(index)
    if index >= 1 and index <= #self.elements then
        table.remove(self.elements, index)
    else
        error("Invalid index!")
    end
end

function Container:setElements(elements)
    self.elements = type(elements) == "table" and elements or error("Invalid value for elements!")
end

function Container:getElements()
    return self.elements
end

function Container:getSelected()
    return self.elements[self.current_selection]
end

function Container:scroll(direction)
    if direction == -1 then
        self.current_selection = self.current_selection - 1

        if self.current_selection < self.start_index then
            self.start_index = self.start_index - 1
        end
    elseif direction == 1 then
        self.current_selection = self.current_selection + 1

        if self.current_selection > self.size then
            self.start_index = self.start_index + 1
        end
    elseif direction ~= 0 then
        error("Invalid direction!")
    end
end

function Container:getVisibleElements()
    local visible_elements = {}

    for i = self.start_index, self.start_index + self.size - 1 do
        table.insert(visible_elements, self.elements[i])
    end

    return visible_elements
end

function Container:getElementAt(x, y)
    local local_x, local_y = self:getPos()

    for i, element in ipairs(self:getVisibleElements()) do
        local_y = local_y + i - 1

        if y == local_y and x >= local_x and x <= #element.content then
            return element
        end
    end

    return nil
end