local function deepCopy(t)
    local copy = {}
    for index, entry in ipairs(t) do
        if type(entry) == "table" then
            copy[index] = deepCopy(entry)
        else
            copy[index] = entry
        end
    end
    return copy
end

return { deepCopy = deepCopy }