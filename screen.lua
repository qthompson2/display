Container = require("bin.display.container")
Output = require("bin.cc-output")
DEFAULT_LISTENERS = require("bin.display.listeners")
ElementTypes = require("bin.display.element_types")
Utils = require("bin.display.utils")

Screen = {}
setmetatable(Screen, {__index = Container})

TIMER_RATE = 0.1

function Screen:new(style)
	local rows, cols = term.getSize()
	local obj = Container:new(1, 1, rows, cols, style)
	obj.listeners = DEFAULT_LISTENERS
	obj.running = false

	obj.current_selection = nil
	obj.held_keys = {}

	obj.type = ElementTypes.SCREEN

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Screen:handleEvents(event_data)
	local event = event_data[1]

	if event == "key" then
		self.held_keys[event_data[2]] = true
	elseif event == "key_up" then
		self.held_keys[event_data[2]] = false
	end

	if type(self.listeners[event]) == "function" then
		self.listeners[event](self, event_data)
	end

	if event == "timer" then
		Output.update()
		Utils.startTimer(TIMER_RATE)
    elseif event == "terminate" then
		self:terminate()
	end
end

function Screen:run()
    Utils.startTimer(TIMER_RATE)
	self.running = true
	while self.running do
		self:draw()
		---@diagnostic disable-next-line: undefined-field
		local event_data = {os.pullEventRaw()}
		self:handleEvents(event_data)
	end
end

function Screen:terminate()
	self.running = false
	Utils.stopAllTimers()
end

function Screen:changeSelection(dir)
	local selectable_elements = self:getSelectableChildren()

	if #selectable_elements == 0 then
		error("No selectable elements found in the screen.")
		return
	end

	if dir ~= 1 and dir ~= -1 then
		error("Invalid direction: " .. tostring(dir))
	end

	if self.current_selection == nil then
		if dir == 1 then
			self.current_selection = 1
		else
			self.current_selection = #selectable_elements
		end

		selectable_elements[self.current_selection].selected = true
	else
		selectable_elements[self.current_selection].selected = false
		if dir == 1 then
			self.current_selection = self.current_selection + 1
			if self.current_selection > #selectable_elements then
				self.current_selection = 1
			end
		else
			self.current_selection = self.current_selection - 1
			if self.current_selection < 1 then
				self.current_selection = #selectable_elements
			end
		end

		selectable_elements[self.current_selection].selected = true
	end
end

return Screen