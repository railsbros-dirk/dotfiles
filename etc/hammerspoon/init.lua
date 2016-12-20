-- SizeUp emulation for hammerspoon
-- To use, you can tweak the key bindings and the margins

local sizeup = { }
local dellUltraWide = "Dell U3415W"
local keys = { }

keys.hyper = {"shift", "ctrl", "alt", "cmd"}

hs.grid.ui.textSize = 100
hs.grid.setMargins("0 0")

---------------
-- Hyper Key --
---------------

-- All credit goes to @prenagha and @ttscoff for their awesome original code that I tweaked for my own devices.
-- Credit 1: https://gist.github.com/ttscoff/cce98a711b5476166792d5e6f1ac5907
-- Credit 2: https://gist.github.com/prenagha/1c28f71cb4d52b3133a4bff1b3849c3e
-- Credit 3: https://gist.github.com/clickysteve/e13a11b8fc9c963c08b3109d95bbacc5

k = hs.hotkey.modal.new({}, "F17")

-- Hyper-key for all the below are setup somewhere... Usually Keyboard Maestro or similar. Alfred doesn't handle them very well, so will set up separate bindings for individual apps below.

hyperBindings = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "TAB", "SPACE", "RETURN", "-", "=", "\\" }

for i,key in ipairs(hyperBindings) do
  k:bind({}, key, nil, function() hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
      k.triggered = true
  end)
end

-- Enter Hyper Mode when F18 is pressed

pressedF19 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 is pressed,
--   send ESCAPE if no other keys are pressed.

releasedF19 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key

f19 = hs.hotkey.bind({}, 'F19', pressedF19, releasedF19)

--------------
-- Bindings --
--------------

-- Media controls
hs.hotkey.bind(keys.hyper, "9", hs.itunes.playpause)
hs.hotkey.bind(keys.hyper, "RETURN", function()
  hs.eventtap.keyStroke({}, "padenter")
end)

--- Split Screen Actions ---
-- Send Window Left
hs.hotkey.bind(keys.hyper, "H", function()
  sizeup.send_window_left()
end)
-- Send Window Right
hs.hotkey.bind(keys.hyper, "L", function()
  sizeup.send_window_right()
end)
-- Send Window Up
hs.hotkey.bind(keys.hyper, "K", function()
  sizeup.send_window_up()
end)
-- Send Window Down
hs.hotkey.bind(keys.hyper, "J", function()
  sizeup.send_window_down()
end)

---- Thrid Screen Actions
-- Send Window Left Third
hs.hotkey.bind(keys.hyper, "U", function()
  sizeup.send_window_left_third()
end)
-- Send Window Middle
hs.hotkey.bind(keys.hyper, "I", function()
  sizeup.send_window_middle()
end)
-- Send Window Middle+Right Third
hs.hotkey.bind(keys.hyper, "P", function()
  sizeup.send_window_middle_right_third()
end)
-- Send Window Right Third
hs.hotkey.bind(keys.hyper, "O", function()
  sizeup.send_window_right_third()
end)

--- Spaces Actions ---

-- Apple no longer provides any reliable API access to spaces.
-- As such, this feature no longer works in SizeUp on Yosemite and
-- Hammerspoon currently has no solution that isn't a complete hack.
-- If you have any ideas, please visit the ticket

--- Snapback Action ---
hs.hotkey.bind(keys.hyper, "\\", function()
  sizeup.snapback()
end)
--- Other Actions ---

-- Make Window Full Screen
hs.hotkey.bind(keys.hyper, "M", function()
  sizeup.maximize()
end)

-- Send Window Center
hs.hotkey.bind(keys.hyper, "N", function()
  sizeup.move_to_center_relative({w=0.70, h=0.95})
end)

--- Reload config
hs.hotkey.bind(keys.hyper, "R", function()
  hs.reload()
end)

--- Show Grid
hs.hotkey.bind(keys.hyper, "G", function()
  if hs.screen(dellUltraWide) ~= nil then
    hs.grid.setGrid('3x2').show()
  else
    hs.grid.setGrid('2x2').show()
  end
end)

-------------------
-- Configuration --
-------------------

-- Margins --
sizeup.screen_edge_margins = {
  top =    0, -- px
  left =   0,
  right =  0,
  bottom = 0
}
sizeup.partition_margins = {
  x = 0, -- px
  y = 0
}

-- Partitions --
sizeup.split_screen_partitions = {
  x = 0.5, -- %
  y = 0.5
}
sizeup.quarter_screen_partitions = {
  x = 0.5, -- %
  y = 0.5
}
sizeup.third_screen_partitions = {
  x = 0.333333333, -- %
  y = 0.5
}

----------------
-- Public API --
----------------
function sizeup.send_window_left_third()
  local s = sizeup.screen()
  local tsp = sizeup.third_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Left Third", {
    x = s.x,
    y = s.y,
    w = (s.w * tsp.x) - sizeup.gutter().x,
    h = s.h
  })
end

function sizeup.send_window_middle()
  local s = sizeup.screen()
  local tsp = sizeup.third_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Middle", {
    x = s.x + (s.w * tsp.x) + g.x,
    y = s.y,
    w = (s.w * tsp.x) - sizeup.gutter().x,
    h = s.h
  })
end

function sizeup.send_window_middle_right_third()
  local s = sizeup.screen()
  local tsp = sizeup.third_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Middle + Right Third", {
    x = s.x + (s.w * tsp.x) + g.x,
    y = s.y,
    w = (s.w * tsp.x * 2) - sizeup.gutter().x,
    h = s.h
  })
end

function sizeup.send_window_right_third()
  local s = sizeup.screen()
  local tsp = sizeup.third_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Right Third", {
    x = s.x + (s.w * tsp.x * 2) + g.x,
    y = s.y,
    w = (s.w * tsp.x) - sizeup.gutter().x,
    h = s.h
  })
end

function sizeup.send_window_left()
  local s = sizeup.screen()
  local ssp = sizeup.split_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Left", {
    x = s.x,
    y = s.y,
    w = (s.w * ssp.x) - sizeup.gutter().x,
    h = s.h
  })
end

function sizeup.send_window_right()
  local s = sizeup.screen()
  local ssp = sizeup.split_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Right", {
    x = s.x + (s.w * ssp.x) + g.x,
    y = s.y,
    w = (s.w * (1 - ssp.x)) - g.x,
    h = s.h
  })
end

function sizeup.send_window_up()
  local s = sizeup.screen()
  local ssp = sizeup.split_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Up", {
    x = s.x,
    y = s.y,
    w = s.w,
    h = (s.h * ssp.y) - g.y
  })
end

function sizeup.send_window_down()
  local s = sizeup.screen()
  local ssp = sizeup.split_screen_partitions
  local g = sizeup.gutter()
  sizeup.set_frame("Down", {
    x = s.x,
    y = s.y + (s.h * ssp.y) + g.y,
    w = s.w,
    h = (s.h * (1 - ssp.y)) - g.y
  })
end

-- snapback return the window to its last position. calling snapback twice returns the window to its original position.
-- snapback holds state for each window, and will remember previous state even when focus is changed to another window.
function sizeup.snapback()
  local win = sizeup.win()
  local id = win:id()
  local state = win:frame()
  local prev_state = sizeup.snapback_window_state[id]
  if prev_state then
    win:setFrame(prev_state)
  end
  sizeup.snapback_window_state[id] = state
end

function sizeup.maximize()
  sizeup.set_frame("Full Screen", sizeup.screen())
end

--- move_to_center_relative(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen.
--- The argument is a size with each key being between 0.0 and 1.0.
--- Example: win:move_to_center_relative(w=0.5, h=0.5) -- window is now centered and is half the width and half the height of screen
function sizeup.move_to_center_relative(unit)
  local s = sizeup.screen()
  sizeup.set_frame("Center", {
    x = s.x + (s.w * ((1 - unit.w) / 2)),
    y = s.y + (s.h * ((1 - unit.h) / 2)),
    w = s.w * unit.w,
    h = s.h * unit.h
  })
end

--- move_to_center_absolute(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen given in pixels.
--- Example: win:move_to_center_relative(w=800, h=600) -- window is now centered and is 800px wide and 600px high
function sizeup.move_to_center_absolute(unit)
  local s = sizeup.screen()
  sizeup.set_frame("Center", {
    x = (s.w - unit.w) / 2,
    y = (s.h - unit.h) / 2,
    w = unit.w,
    h = unit.h
  })
end

------------------
-- Ctrl / ESC   --
------------------

send_escape = false
last_mods = {}

control_key_handler = function()
  send_escape = false
end

control_key_timer = hs.timer.delayed.new(0.1, control_key_handler)

control_handler = function(evt)
  local new_mods = evt:getFlags()
  if last_mods["ctrl"] == new_mods["ctrl"] then
    return false
  end
  if not last_mods["ctrl"] then
    last_mods = new_mods
    send_escape = true
    control_key_timer:start()
  else
    if send_escape then
      hs.eventtap.keyStroke({}, "ESCAPE")
    end
    last_mods = new_mods
    control_key_timer:stop()
  end
  return false
end

control_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, control_handler)
control_tap:start()

other_handler = function(evt)
  send_escape = false
  return false
end

other_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, other_handler)
other_tap:start()

------------------
-- Internal API --
------------------

-- SizeUp uses no animations
hs.window.animation_duration = 0

-- Initialize Snapback state
sizeup.snapback_window_state = { }

-- return currently focused window
function sizeup.win()
  return hs.window.focusedWindow()
end

-- display title, save state and move win to unit
function sizeup.set_frame(title, unit)
  -- hs.alert.show(title)
  local win = sizeup.win()
  sizeup.snapback_window_state[win:id()] = win:frame()
  return win:setFrame(unit, 0)
end

-- screen is the available rect inside the screen edge margins
function sizeup.screen()
  local screen = sizeup.win():screen():frame()
  local sem = sizeup.screen_edge_margins
  return {
    x = screen.x + sem.left,
    y = screen.y + sem.top,
    w = screen.w - (sem.left + sem.right),
    h = screen.h - (sem.top + sem.bottom)
  }
end
-- gutter is the adjustment required to accomidate partition
-- margins between windows
function sizeup.gutter()
  local pm = sizeup.partition_margins
  return {
    x = pm.x / 2,
    y = pm.y / 2
  }
end

--- Display message after loading
hs.alert.show("Config loaded")
