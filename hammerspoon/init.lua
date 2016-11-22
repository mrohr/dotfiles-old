local hyper = {"shift", "cmd", "alt", "ctrl"}
local mover = {"cmd", "alt"}
local moverShift = {"cmd", "alt", "shift"}
hs.window.animationDuration = 0
hs.hints.style = 'vimperator'
require("hs.application")
require("hs.window")
require("hs.grid")
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.setGrid('2x2')
hs.grid.setGrid('6x6', '2560x1440')



---
--- window selector
---
hs.hotkey.bind({"alt"}, "Tab", function()
	hs.hints.windowHints(nil, nil, true)
	end)


-- 
-- window management
--
hs.hotkey.bind(mover, 'f', function() 
    hs.grid.maximizeWindow() 
    end)


hs.hotkey.bind(mover, 'h', function()
    hs.grid.pushWindowLeft()
    end)
hs.hotkey.bind(mover, 'j', function()
    hs.grid.pushWindowDown()
    end)
hs.hotkey.bind(mover, 'k', function()
    hs.grid.pushWindowUp()
    end)
hs.hotkey.bind(mover, 'l', function()
    hs.grid.pushWindowRight()
    end)

hs.hotkey.bind(moverShift, 'h', function()
    hs.grid.resizeWindowThinner()
    end)
hs.hotkey.bind(moverShift, 'j', function()
    hs.grid.resizeWindowShorter()
    end)
hs.hotkey.bind(moverShift, 'k', function()
    hs.grid.resizeWindowTaller()
    end)
hs.hotkey.bind(moverShift, 'l', function()
    hs.grid.resizeWindowWider()
    end)





--
-- window control
--
hs.hotkey.bind(hyper, 'k', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowNorth()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'j', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowSouth()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'l', function()
    if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowEast()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'h', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowWest()
    else
        hs.alert.show("No active window")
    end
end)


--
-- hot memes
--
hs.hotkey.bind(mover, 's', function()
    hs.eventtap.keyStrokes('¯\\_(ツ)_/¯')
    end)

--