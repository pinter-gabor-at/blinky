-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	-- Turn blue LED on and off
	local M = dofile("ESP12.lua")
	node.task.post(function()
		gpio.mode(M.BLUELED, gpio.OUTPUT)
		print("\nBlue LED ON")
		gpio.write(M.BLUELED, 0)
	end)
	tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
		print("\nBlue LED OFF")
		gpio.write(M.BLUELED, 1)
		return T.endtest(true)
	end)
end
