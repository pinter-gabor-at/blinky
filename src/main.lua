-- Main program

-- Welcome message
print("\nBlinky V2.1\n\n")

-- Config
if not pcall(loadfile("config.lua")) and
   not pcall(loadfile("config.default.lua")) then
	-- Fallback
	HOSTNAMEPREFIX = "FALLBACK-"
	PATTERN = "- - -   --- --- ---   "
end

-- Station mode
wifi.setmode(wifi.STATION)
-- Clean start
wifi.sta.clearconfig()
-- Set hostname to something unique and recognizable
wifi.sta.sethostname(HOSTNAMEPREFIX .. "BLINKY-" ..
	(((wifi.sta.getmac()):gsub(":", "")):sub(7):upper()))

-- Pattern generator
ledpattern = require("ledpattern")

-- Convert 'data' in 'format' to blinky format
local function toblinky(format, data)
	if format == "text" then
		local texttomorse = dofile("texttomorse.lua")
		local morsetoblinky = dofile("morsetoblinky.lua")
		return morsetoblinky.toblinky(texttomorse.tomorse(data))
	end
	if format == "morse" then
		local morsetoblinky = dofile("morsetoblinky.lua")
		return morsetoblinky.toblinky(data)
	end
	return data
end

-- Repeat timer
local itmr

-- Start
function start()
	-- Speed
	ledpattern.interval = 1200/(WPM and WPM or 5)

	-- A counter for fancy messages
	local ct = 0

	-- Try to keep ledpattern.pattern updated
	-- regularily from the internet
	if WIFI and URLS then
		-- Connect
		local connect = require("connect")
		connect.known = WIFI
		connect.urls = URLS
		connect.callback =
			function(data)
				if data then
					-- Update pattern
					ledpattern.pattern = toblinky(FORMAT, data)
					ct = ct+1
					print(ct, ledpattern.pattern)
					-- OTA update
					dofile("update.lua")(
						OTAS,
						"V2.1",
						function()
							-- Next
							if itmr then
								return itmr:start()
							end
						end)
				end
			end
		-- Repeat timer
		itmr = tmr.create()
		itmr:register(60000, tmr.ALARM_SEMI, connect.start)
		-- First
		connect.start()
	else
		-- Fallback
		ledpattern.pattern = toblinky(FORMAT, PATTERN)
	end

	-- Create pattern
	return ledpattern.start()
end

-- In case we have to stop it
function stop(callback)
	-- Stop pattern
	ledpattern.stop()
	-- Stop timer
	if itmr then
		itmr:unregister()
		itmr = nil
	end
end

-- Autostart
start()
