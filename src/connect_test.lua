-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	local M = dofile("connect.lua")

	-- Set it to true, if the test succeed at least once
	local success = false

	-- Print the data
	local function printit(data)
		if data then
			-- Got it
			success = true
			print(data)
			print()
		end
	end

	-- Test
	node.task.post(function()
		print("\nTrying to get data from alternative locations.")
		-- As fast as possible
		M.interval = 1
		M.known = 
			{
				{pattern="^PINTER%-TEST", pwd="password", pref=10},
				{pattern="^PINTER", pwd="password", pref=5},
				{pattern=""},
			}
		M.urls = 
			{
				"http://nowhere.sun/nothing.txt",
				"http://pintergabor.eu/blinky/PINTER%20GABOR.txt",
			}
		M.callback = printit
		M.start()
	end)

	-- End test cleanly
	tmr.create():alarm(30000, tmr.ALARM_SINGLE, function()
		M.callback =
			function(data)
				printit(data)
				M.stop()
				print("Done")
				return T.endtest(success)
			end
	end)
end
