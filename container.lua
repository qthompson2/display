Element = require("element")
ElementTypes = require("elementTypes")

Container = {}
setmetatable(Container, {__index = Element})

function Container:new(elements, x, y, size, palette)
    local obj = Element:new(x, y, palette)
    obj.elements = elements
    obj.current_selection = 1
    obj.start_index = 1
    obj.size = size
    obj.max_element_length = 0

    for _, element in ipairs(elements) do
        if element:getType() == ElementTypes.BUTTON or element:getType() == ElementTypes.TEXTBOX or element:getType() == ElementTypes.BUNDLE then
            obj.max_element_length = math.max(obj.max_element_length, element:len())
        else
            error("Invalid element type!")
        end
    end

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Container:add(element)
    if element.getType == nil then
        error("Invalid element!")
    elseif element:getType() == ElementTypes.BUTTON or element:getType() == ElementTypes.TEXTBOX or element:getType() == ElementTypes.BUNDLE or element:getType() == ElementTypes.TEXTFIELD then
        table.insert(self.elements, element)
        self.max_element_length = math.max(self.max_element_length, element:len())
    else
        error("Invalid element type!")
    end
end

function Container:addBulk(elements)
    for _, element in ipairs(elements) do
        self:add(element)
    end
end

function Container:remove(index)
    if index >= 1 and index <= #self.elements then
        if self.max_element_length == #self.elements[index]:getContent() then
            self.max_element_length = 0

            for _, element in ipairs(self.elements) do
                self.max_element_length = math.max(self.max_element_length, element:len())
            end
        end

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

function Container:getSelectedElement()
    return self.elements[self.current_selection]
end

function Container:clearSelection()
    self:setSelected(false)

    for _, element in ipairs(self.elements) do
        element:clearSelection()
    end
end

function Container:scroll(direction)
    if direction == -1 then
        if self.current_selection > 1 then
            self.current_selection = self.current_selection - 1

            if self.current_selection < self.start_index then
                self.start_index = self.start_index - 1
            end
        end
    elseif direction == 1 then
        if self.current_selection < #self.elements then
            self.current_selection = self.current_selection + 1

            if self.current_selection > self.start_index + self.size - 1 then
                self.start_index = self.start_index + 1
            end
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

function Container:findPos(x, y)
    error("Container:findPos() must be implemented in child classes!")
end

function Container:getSize()
    return self.size
end

function Container:setSize(size)
    self.size = type(size) == "number" and size or error("Invalid value for size!")
end

function Container:len()
    error("Container:len() must be implemented in child classes!")
end

return Container