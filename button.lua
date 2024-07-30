TextBox = require("textbox")

Button = TextBox:new()

function Button:new(text, action, x, y, fg, bg, selected_fg, selected_bg)
    local obj = TextBox:new(text, x, y, fg, bg)
    obj.action = action or function() end
    obj.selected = false
    obj.selected_fg = selected_fg or colours.black
    obj.selected_bg = selected_bg or colours.yellow and term.isColour() or colours.white

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Button:draw()
    if self.selected then
        term.setBackgroundColor(self.selected_bg)
        term.setTextColor(self.selected_fg)
    else
        term.setBackgroundColor(self.bg)
        term.setTextColor(self.fg)
    end
    term.setCursorPos(self.x, self.y)
    term.write(self.text)
end

function Button:select()
    self.selected = true
end

function Button:deselect()
    self.selected = false
end

return Button