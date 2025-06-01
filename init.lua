if not fs.exists("/git-over-here.lua") then
	print("git-over-here not found, preparing installation...")
	shell.run("pastebin get h8np44GM /git-over-here.lua")
end
if not fs.exists("/bin/cc-output") then
	print("cc-output not found, preparing installation...")
	shell.run("git-over-here qthompson2/cc-output /bin/cc-output")
end

return {
	Style = require("display.style"),
	elements = {
		Element = require("display.element"),
		Textbox = require("display.textbox"),
	},
	containers = {
		Container = require("display.container"),
		Screen = require("display.screen"),
	},
	ElementTypes = require("display.element_types"),
	Utils = require("display.utils"),
}