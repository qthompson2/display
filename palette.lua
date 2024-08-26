Palette = {}

function Palette:new(standard_fg, standard_bg, selected_fg, selected_bg)
    local obj = {}

    obj.standard = {
        fg = standard_fg,
        bg = standard_bg
    }

    obj.selected = {
        fg = selected_fg,
        bg = selected_bg
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Palette:apply(name)
    term.setTextColor(self[name].fg)
    term.setBackgroundColor(self[name].bg)
end

function Palette:add(name, fg, bg)
    self[name] = {
        fg = fg,
        bg = bg
    }
end

function Palette:applyStandard()
    term.setTextColor(self.standard.fg)
    term.setBackgroundColor(self.standard.bg)
end

function Palette:applySelected()
    term.setTextColor(self.selected.fg)
    term.setBackgroundColor(self.selected.bg)
end

return Palette