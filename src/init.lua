-- Start of the program

-- Delayed start main to prevent bootloop
local function startmain()
	tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
		dofile("main.lua")
	end)
end

-- Call setup, if exists, for OTA updates
if not pcall(loadfile("setup.lua", startmain) then
	return startmain()
end
