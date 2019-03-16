-- Main program

-- Includes
local led = require("led")

-- Blink blue LED
tmr.create():alarm(500, tmr.ALARM_AUTO, function()
    local state = not led.getstate()
    print("Blue LED " .. (state and "OFF" or "ON"))
    return led.setstate(state)
end)
