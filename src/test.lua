-- For line-by-line execution in ESPlorer
local function _()
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
	dofile("testutil_test.lua")
	dofile("ESP12_test.lua")
	dofile("led_test.lua")
	dofile("ledpattern_test.lua")
	dofile("texttomorse_test.lua")
	dofile("morsetoblinky_test.lua")
	dofile("wlistsimple_test.lua")
	dofile("wlistfancy_test.lua")
	dofile("wrange_test.lua")
	dofile("wconnect_test.lua")
	dofile("wresolve_test.lua")
	dofile("whttp_test.lua")
	dofile("connect_test.lua")
	dofile("main.lua")
	start()
	stop()
	-- List globals
	for k, v in pairs(_G) do print(k, v) end
	-- Get heap
	print(node.heap())
	-- Reboot
	node.restart()
end
