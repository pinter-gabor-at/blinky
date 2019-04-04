-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	local M = dofile("wconnect.lua")
	node.task.post(function()
		print("\nTrying to connect to the PINTER-TEST network.")
		M.connect(
			{ssid="PINTER-TEST", pwd="password"},
			function(t)
				if t then
					T.endtest(true, "IP: " .. t.IP)
				else
					T.endtest(false, "Failed")
				end
			end)
	end)
end
