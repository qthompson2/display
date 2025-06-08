if not fs.exists("/git-over-here.lua") then
	print("git-over-here not found, preparing installation...")
	shell.run("pastebin get h8np44GM /git-over-here.lua")
end
if not fs.exists("/bin/cc-output") then
	print("cc-output not found, preparing installation...")
	shell.run("git-over-here qthompson2/cc-output /bin/cc-output")
end

return {
	Style = require("bin.display.style"),
	elements = {
		Element = require("bin.display.element"),
		Textbox = require("bin.display.textbox"),
		TextButton = require("bin.display.textbutton"),
	},
	containers = {
		Container = require("bin.display.container"),
		Screen = require("bin.display.screen"),
	},
	ElementTypes = require("bin.display.element_types"),
	Utils = require("bin.display.utils"),
}