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

function Palette:applyInverted(name)
    term.setTextColor(self[name].bg)
    term.setBackgroundColor(self[name].fg)
end

function Palette:update(name, fg, bg)
    self[name] = {
        fg = fg,
        bg = bg
    }
end

--Deprecated
function Palette:applyStandard()
    self:apply("standard")
end

--Deprecated
function Palette:applySelected()
    self:apply("selected")
end

return Palette