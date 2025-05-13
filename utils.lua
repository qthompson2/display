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

local function merge(t1, t2)
    local merged = {}
    for index, entry in pairs(t2) do
        merged[index] = entry
    end
    for index, entry in pairs(t1) do
        merged[index] = entry
    end
    return merged
end

local function split(str, sep)
    if sep == nil or #sep == 0 then
        sep = "%s"
    end
    local result = {}
    for match in str:gmatch("([^" .. sep .. "]+)") do
        table.insert(result, match)
    end
    return result
end

return {
    deepCopy = deepCopy,
    merge = merge,
    split = split,
}