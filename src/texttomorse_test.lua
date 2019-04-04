-- Test
return function(callback)
	local T = require("testutil")
	T.callback = callback

	-- Convert a pattern
	local M = dofile("texttomorse.lua")
	node.task.post(function()
		local text = "PINTER GABOR  "
		print(("\nText: %q"):format(text))
		local morse = M.tomorse(text)
		print(("Morse code: %q"):format(morse))
		if morse == ".--. .. -. - . .-.   --. .- -... --- .-.     " then
			T.endtest(true, "Correct.")
		else
			T.endtest(false, "It does not work.")
		end
	end)
end
