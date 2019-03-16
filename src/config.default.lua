-- Configure networks
-- Please rename this file to "config.lua" and edit parameters

-- Hostname prefix
HOSTNAMEPREFIX = "DEFAULT-"

-- Known networks and their passwords
--  pattern = LUA pattern to match SSID
--    Usually starts with "^" to anchor the pattern, 
--    and encodes special characters line '-' as "%-"
--  pwd = Password
--    If omitted, or empty, only open networks are matched to pattern
--  pref = Preference
--    Adjust signal strength by this value to make even weaker
--    networks more preferable. The usual range is -10 .. +10.
WIFI = {
	{pattern="^PINTER%-TEST",   pwd="password",          },
	{pattern="^PINTER%-GUEST",                   pref= -5},
	{pattern="",                                 pref= -9},
}

-- Internet addresses of the pattern, URLencoded
URLS = {
	"http://192.168.2.2:1080/blinky/PINTER%20GABOR.txt",
	"http://pintergabor.eu/blinky/PINTER%20GABOR.txt",
}

-- Pattern format
--   "text" = plain text, like "PINTER GABOR"
--   "morse" = morse code, like ".--. .. -. - . .-.   --. .- -... --- .-.     "
--   "blinky" = raw blinky pattern, like "- --- --- -    - -    --- -    ---    -    - --- -       --- --- -    - ---    --- - - -    --- --- ---    - --- -         "
FORMAT = "text"

-- Pattern speed
-- The length of one element is 1200/WPM ms
WPM = 5
