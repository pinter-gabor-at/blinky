-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	local M = dofile("wresolve.lua")
	node.task.post(function()
		print("\nTrying to resolve www.pintergabor.eu.")
		M.resolve(
			"www.pintergabor.eu",
			function(ip)
				if ip then
					T.endtest(true, "IP: " .. ip)
				else
					T.endtest(false, "Failed")
				end
			end)
	end)
end
