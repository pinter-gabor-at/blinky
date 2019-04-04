-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	-- Turn blue LED on and off
	local M = dofile("ledpattern.lua")
	node.task.post(function()
		print("\nBlink blue LED for 5 seconds")
		M.pattern = "010110111"
		M.start()
	end)
	tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
		print("Done")
		M.stop()
		return T.endtest(true)
	end)
end
