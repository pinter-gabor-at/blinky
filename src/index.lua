-- OTA update

-- This version
local newversion = "V2.1"

-- It is called with pcall(loadstring(body), url, version)
-- Get parameters
local url, version = ...

-- Check version
if not version <= newversion then
	error("Not newer")
end

-- List of files to download
local flist = {
config.default.lua
connect.lua
ESP12.lua
led.lua
ledpattern.lua
main.lua
morsetoblinky.lua
texttomorse.lua
update.lua
wconnect.lua
whttp.lua
wlistfancy.lua
wlistsimple.lua
wrange.lua
wresolve.lua
}

-- Index of flist
local i = 0

-- Download a file
local function download(status, body, headers)
	-- Save the received file
	if status and status == 200 then
		local f = file.open(flist[i], "w")
		f:write(body)
		f:close()
		f = nil
	end
	-- Get the next
	i = i+1
	if i <= #flist then
		return http.get(base .. flist[i], nil, download)
	else
		-- End: reboot
		return node.restart()
	end
end

-- Download files
return download()
