# Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA

Blinky is usually the first program anybody writes when experimenting with a new embedded HW or when learning a new programming language. It is almost as popular as the "Hello world" program, especially for tiny embedded devices, that do not have a standard output terminal, but have an LED connected to one of their pins.

For ESP12F it can be written in a few lines, like in
[.../simple/src/main.lua](https://gitlab.com/pintergabor/blinky/blob/simple/src/main.lua)

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

It is simple.  
It is ugly.  
Of course it can be made even simpler, and even uglier, but that is not the way to learn new skills.


A nicer solution is to define symbolic names for all pins, and encapsulate the LED blinking function in a module, like in
[.../nice/src/main.lua](https://gitlab.com/pintergabor/blinky/blob/nice/src/main.lua)

    -- Includes
    local led = require("led")

    -- Blink blue LED
    tmr.create():alarm(500, tmr.ALARM_AUTO, function()
        local state = not led.getstate()
        print("Blue LED " .. (state and "OFF" or "ON"))
        led.setstate(state)
    end)


And it is even nicer to define the blinking patterns in a string, like in [.../pattern/src/main.lua](https://gitlab.com/pintergabor/blinky/blob/pattern/src/main.lua)

    -- Includes
    local ledpattern = require("ledpattern")

    -- Set pattern and start blinking
    ledpattern.pattern = " - --- --- -    - -    --- -    ---    -    - --- -       --- --- -    - ---    --- - - -    --- --- ---    - --- -         "
    ledpattern.start()

But the ultimate solution is to get the blinking pattern from the internet, like in
[.../pattern/src/main.lua](https://gitlab.com/pintergabor/blinky/blob/pattern/src/main.lua)

    -- Config
    if not pcall(loadfile("config.lua")) and
       not pcall(loadfile("config.default.lua")) then
       -- Fallback
       HOSTNAME = "BLINKY-FALLBACK"
       PATTERN = "- - -   --- --- ---   "
    end

    -- Station mode
    wifi.setmode(wifi.STATION)
    -- Clean start
    wifi.sta.clearconfig()
    -- Set hostname to something recognizable
    wifi.sta.sethostname(HOSTNAME)

    -- Pattern generator
    local ledpattern = require("ledpattern")

    -- Try to keep ledpattern.pattern updated
    -- regularily from the internet
    if URLS then
        local connect = require("connect")
        connect.start(WIFI, URLS, 60000,
            function(data)
                if data then
                    -- Update pattern
                    ledpattern.pattern = data
                end
            end)
    else
        -- Fallback
        ledpattern.pattern = PATTERN
    end

    -- Create pattern
    ledpattern.start()

To make the task even more difficult, let's pretend that blinking is the most important thing in the world.
Try to access the internet using different connections, and search for the pattern on different websites.

The configuration parameters are in
[.../master/src/config.lua](https://gitlab.com/pintergabor/blinky/blob/master/src/config.lua),
or, if that is missing, in
[.../master/src/config.default.lua](https://gitlab.com/pintergabor/blinky/blob/master/src/config.default.lua).
