-- Connect to all know networks in range, and get data

-- Includes
local wrange = require("wrange")
local wconnect = require("wconnect")
local whttp = require("whttp")

-- Module start
local M = {}


-- Index
local index


-- Known networks
-- {{pattern, pwd, pref}, ...}
--   pattern is a lua pattern to match actual SSIDs.
M.known = {}


-- List of alternative URLs
-- All should contain the same data, but might be accessible
-- at different times, and through different SSIDs.
M.urls = {}


-- Called after getting the data
-- callback = callback(data)
--   data is the data we got
M.callback = nil


-- Start
function M.start()

	-- To prevent repeated calls
	local running

	-- Execute callback and restart timer
	local function docallback(data)
		if M.callback then
			return node.task.post(function()
				M.callback(data)
				running = nil
			end)
		else
			running = nil
		end
	end

	-- Iterator, defined later
	local iter

	-- Get data
	-- Callback of whttp.mget(..., callback(url, status, data))
	--   url = url of the data
	--   status = regular HTTP status code, or -1 on error
	--   data = body
	local function getdata(url, status, data)
		if url and (0 <= status) then
			print("Got data from " .. url)
			-- Success
			return docallback(data)
		else
			-- Next
			return node.task.post(iter)
		end
	end

	-- Get connected
	--   t = {IP, netmask, gateway}
	local function getip(t)
		if t then
			print("Got IP: " .. t.IP)
			return whttp.mget(M.urls, nil, getdata)
		else
			-- Next
			return node.task.post(iter)
		end
	end

	-- Callback of wrange.getlist(..., callback(t))
	--   t = {{ssid, bssid, pwd, rssi, pref}, ...}
	local function process(t)
		local i

		-- For each know networks in the list
		iter = function()
			i = i + 1
			if i <= #t then
				print("Connecting to " .. t[i].ssid)
				return wconnect.connect(t[i], getip)
			else
				-- End of the list, and no result
				return docallback()
			end
		end

		-- Start evaluating the first
		i = 0
		return node.task.post(iter)
	end

	-- Get list, connect, and try to get data from all 
	-- known networks and URLs until it succeeds.
	if not running then
		running = true
		-- Get list of known networks in range,
		-- ordered by preference and 
		return wrange.getlist(M.known, process)
	end
end


-- Module end
return M
