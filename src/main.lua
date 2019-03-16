-- Main program

-- Blue LED
-- 1=OFF, 0=ON
local BLUELED = 4

-- Blink blue LED
gpio.mode(BLUELED, gpio.OUTPUT)
tmr.create():alarm(500, tmr.ALARM_AUTO, function()
    local state = 1 - gpio.read(BLUELED)
    print("Blue LED " .. (state == 1 and "OFF" or "ON"))
    gpio.write(BLUELED, state)
end)
