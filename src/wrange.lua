-- Get the list of known networks in range

-- Module start
local M = {}


-- Create list of known networks in range,
-- ordered by signal strength, modified by preference.
--   known = {{pattern, pwd, pref}, ...}
--     pattern is a lua pattern to match actual SSIDs.
--   callback = callback({{ssid, bssid, pwd, rssi, pref}, ...}).
function M.getlist(known, callback)

	-- Callback of wifi.sta.getap(1, callback(t))
	local function aplist(t)
		-- This will be the list
		local list = {}
		-- Fill it
		do
			-- Extra preference for the currently used network
			local cssid, _, cbssid_set, cbssid = wifi.sta.getconfig()
			-- For each network
			for bssid, v in pairs(t) do
				local ssid, rssi, authmode =
					string.match(v, "([^,]+),([^,]+),([^,]+)")
				rssi = tonumber(rssi)
				authmode = tonumber(authmode)
				-- Compare it to known networks
				for _, v in ipairs(known) do
					local pattern = v.pattern
					local pwd = v.pwd or ""
					local pref = v.pref or 0
					if string.find(ssid, pattern) and
						((pwd == "" and authmode == 0) or 
						 (pwd ~= "" and authmode ~= 0)) then
						-- Found
						-- Add some extra preference to the currently used network
						if ssid == cssid and
							(cbssid_set == 0 or bssid == cbssid) then
							pref = pref + 5
						end
						-- Add it to the table
						table.insert(list,
							{ssid=ssid, bssid=bssid, pwd=pwd,
							rssi=rssi, pref=(rssi+pref)})
					end
				end
			end
		end
		-- Sort it by preference
		table.sort(list, function(i, j)
			return i.pref > j.pref
		end)
		-- Return it
		if callback then
			node.task.post(function()
				return callback(list)
			end)
		end
	end

	-- Create the list, filter and return it later
	wifi.sta.getap(1, aplist)
end


-- Print list
function M.printlist(list)
	print(string.format("\n### %-32s %-18s %-16s %-4s %-4s",
		"SSID", "BSSID", "PASSWORD", "RSSI", "PREF"))
	for k, v in ipairs(list) do
		print(string.format("%2d. %-32s %-18s %-16s %3d  %3d",
			k, v.ssid, v.bssid, v.pwd, v.rssi, v.pref))
	end
end


-- Module end
return M
