-- For line-by-line execution in ESPlorer
if false do
	tmr.create():alarm(3000, tmr.ALARM_SINGLE, function() print("Hello world") end)
	-- Station mode
	wifi.setmode(wifi.STATION)
	-- Clean start
	wifi.sta.clearconfig()
	-- Set hostname to something recognizable
	wifi.sta.sethostname("BLINKY-TEST")
	-- Check IP
	print(wifi.sta.getip())
	-- Tests
	dofile("main.lua")
	-- List globals
	for k, v in pairs(_G) do print(k, v) end
	-- Get heap
	print(node.heap())
	-- Reboot
	node.restart()
end
