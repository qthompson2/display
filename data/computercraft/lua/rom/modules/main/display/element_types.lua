ElementTypes = {
    TEXTBOX = "textbox",
    BUTTON = "button",
    ROW = "row",
    COLUMN = "column",
    DROPDOWNMENU = "dropdownmenu",
    TEXTFIELD = "textfield",
    ELEMENTBUNDLE = "elementbundle",
    BIGTEXTBOX = "bigtextbox",
    IMAGE = "image",

    checkEquivalency = function(type1, type2)
        if type1 == type2 then
            return true
        else
            return false
        end
    end
}

return ElementTypes