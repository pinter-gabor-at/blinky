-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	-- Turn blue LED on and off
	local M = dofile("led.lua")
	node.task.post(function()
		print("\nBlue LED ON")
		M.on()
	end)
	tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
		print("Blue LED OFF")
		M.off()
		return T.endtest(true)
	end)
end
