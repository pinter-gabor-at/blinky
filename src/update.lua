-- OTA update

-- Get and execute OTA index file from one of 'urls'
-- Call 'callback' if no OTA index file is found,
-- or if the OTA index file is not newer than the current version.
--   'urls' = list of URLs of the same OTA index file
--   'version' = current version
return function(urls, version, callback)
	local whttp = require("whttp")

	-- Interpret OTA index
	local function interpret(url, body)
		-- Try to execute the update function
		if not pcall(loadstring(body), url:match(".*/"), version) then
			-- Call callback if OTA index cannot,
			-- or does not want to update.
			return node.task.post(callback)
		end
	end

	-- Get OTA index
	-- Callback of whttp.mget(..., callback(url, status, body))
	--   url = url of the data
	--   status = regular HTTP status code, or -1 on error
	--   body = OTA index
	local function getdata(url, status, body)
		if url and status == 200 then
			print("Got OTA index from " .. url)
			-- Success
			return interpret(url, body)
		else
			-- Failure
			return node.task.post(callback)
		end
	end

	-- Try to get OTA index from every URLs
	return whttp.mget(urls, nil, getdata)
end
