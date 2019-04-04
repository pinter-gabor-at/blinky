-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	local M = dofile("wrange.lua")
	node.task.post(function()
		print("\nOpen networks and PINTER* networks in range, sorted by preference:")
		M.getlist(
			{
				{pattern="^PINTER%-TEST", pwd="password", pref=10},
				{pattern="^PINTER", pwd="password", pref=5},
				{pattern=""},
			},
			function(t)
				M.printlist(t)
				T.endtest(true)
			end)
	end)
end
