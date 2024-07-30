TextBox = {}

function TextBox:new(text, x, y, fg, bg)
    local obj = {}
    obj.text = text or ""
    obj.x = x or 1
    obj.y = y or 1
    obj.fg = fg or colours.white
    obj.bg = bg or colours.black

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function TextBox:draw()
    term.setBackgroundColor(self.bg)
    term.setTextColor(self.fg)
    term.setCursorPos(self.x, self.y)
    term.write(self.text)
end

return TextBox