-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	-- It is always successfull
	node.task.post(function()
		print("\nThere is nothing to test.")
		return T.endtest(true)
	end)
end
