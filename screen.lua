Container = require("display.container")
Output = require("bin.cc-output")

Screen = {}
setmetatable(Screen, {__index = Container})

TIMER_RATE = 0.1

function Screen:new(style)
	local rows, cols = term.getSize()
	local obj = Container:new(1, 1, rows, cols, style)
	obj.listeners = {}

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Screen:handleEvents()
	---@diagnostic disable-next-line: undefined-field
	local event_data = {os.pullEvent()}
	local event = event_data[1]

	if type(self.listeners[event]) == "function" then
		self.listeners[event](self, event_data)
	end

	if event == "timer" then
		Utils.startTimer(TIMER_RATE)
    elseif event == "terminate" then
        Utils.stopAllTimers()
	end
end

function Screen:run()
    Utils.startTimer(TIMER_RATE)
	while true do
        self:draw()
        Output.update()
		self:handleEvents()
	end
end

return Screen