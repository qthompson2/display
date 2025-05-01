Textbox = require("display.textbox")
ElementTypes = require("display.element_types")

TextField = {}
setmetatable(TextField, {__index = Textbox})

function TextField:new(placeholder_text, x, y, palette, length)
    local obj = Textbox:new(placeholder_text or "...", x, y, palette)
    obj.type = ElementTypes.TEXTFIELD
    obj.input = ""

    obj.length = length
    obj.start_index = 1
    obj.current_index = 1

    obj.on_input = nil

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function TextField:getInput()
    return self.input
end

function TextField:setInput(input)
    self.input = input
end

function TextField:appendInput(character)
    self.input = self.input .. character
    self.current_index = self.current_index + 1

    if self.start_index + self.current_index > self.length then
        self:scroll(1)
    end

    if self.on_input then
        self.on_input(self.input)
    end
end

function TextField:backspace()
    self.input = self.input:sub(1, -2)
    self.current_index = self.current_index - 1
    if #self.input >= self.length then
        self:scroll(-1)
    end

    if self.on_input then
        self.on_input(self.input)
    end
end

function TextField:scroll(dir)
    if dir == -1 then
        if self.start_index > 1 then
            self.start_index = self.start_index - 1
        end
    elseif dir == 1 then
        if self.start_index + self.length - 1 < #self.input then
            self.start_index = self.start_index + 1
        end
    end
end

function TextField:draw(x, y)
    self:setPos(x, y)

    if self:getSelected() then
        self.palette:applySelected()

        term.setCursorPos(self.x, self.y)
        term.write(self.input:sub(self.start_index, self.start_index + self.length - 1).."_")
    else
        self.palette:applyStandard()

        term.setCursorPos(self.x, self.y)

        if self.input == "" then
            term.write(self.content:sub(1, self.length))
        else
            term.write(self.input:sub(1, self.length))
            if #self.input > self.length then
                term.write("...")
            end
        end
    end
end

function TextField:simpleDraw(x, y, monitor)
    self:setPos(x, y)

    monitor.setCursorPos(self.x, self.y)

    if self.input == "" then
        monitor.write(self.content:sub(1, self.length))
    else
        monitor.write(self.input:sub(1, self.length))
        if #self.input > self.length then
            monitor.write("...")
        end
    end
end

function TextField:len()
    return self.length
end

function TextField:setOnInput(on_input)
    self.on_input = on_input
end

return TextField