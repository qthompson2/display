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

local function wrap(str, width)
	local result = {}
	local currentLine = ""
	for word in str:gmatch("%S+") do
		if #currentLine + #word + 1 > width and #currentLine > 0 then
			table.insert(result, currentLine)
			currentLine = word
		else
			if #currentLine > 0 then
				currentLine = currentLine .. " "
			end
			currentLine = currentLine .. word
		end
	end
	if #currentLine > 0 then
		table.insert(result, currentLine)
	end
	return result
end

local timers = {}

local function startTimer(seconds)
	---@diagnostic disable-next-line: undefined-field
	local timerId = os.startTimer(seconds)
	timers[timerId] = true
	return timerId
end

local function stopAllTimers()
	for timerId in pairs(timers) do
		---@diagnostic disable-next-line: undefined-field
		os.cancelTimer(timerId)
		timers[timerId] = nil
	end
end

return {
	deepCopy = deepCopy,
	merge = merge,
	split = split,
	wrap = wrap,
    startTimer = startTimer,
    stopAllTimers = stopAllTimers,
}