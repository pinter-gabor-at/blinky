-- Start of the program

-- Delayed start main to prevent bootloop
print("\nBlinky V2.1\n\n")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
	dofile("main.lua")
end)
