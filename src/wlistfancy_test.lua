-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	local M = dofile("wlistfancy.lua")
	node.task.post(function()
		print("\nAccessible networks in fancy form:")
		M.listap(function()
			print("\nDone")
			T.endtest(true)
		end)
	end)
end
