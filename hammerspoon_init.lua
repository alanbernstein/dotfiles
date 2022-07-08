-- http://www.hammerspoon.org/go/
-- global keyboard shortcuts:
-- cmd+alt+ctrl+W   hello world (popup notification)
-- ctrl-alt-S       headphones (spoken) - for testing whether headphone jack is broken
-- ctrl-alt-U       unmount SD card (ad-hoc)
-- ctrl-alt-Q       play random spotify album (favorite)
-- ctrl-alt-N       play random spotify album (new)
-- ctrl-alt-M       toggle mic volume 0/100
-- ctrl-alt-P       launch/focus keepass
-- ctrl-alt-Z       lock screen
-- ctrl-alt-Y       move focused window to center of screen (to deal with "lost" windows)

mod = {"ctrl", "alt"}
cmd_dir = os.getenv("HOME") .. "/cmd/"
python3 = "/usr/local/bin/python3"

--hs.hotkey.bind(mod, "Z", function()
--  hs.caffeinate.lockScreen()
--end)

hs.hotkey.bind(mod, "Z", hs.caffeinate.lockScreen)


hs.hotkey.bind(mod, "P", function()
-- this works perfectly with spotify
  --hs.application.launchOrFocus("KeePassX")
  local win = hs.window.focusedWindow()
  win:maximize()
  win:unminimize()
  --  hs.eventtap.event.newKeyEvent(mods, key, isdown)
  hs.alert.show("BROKEN: launched or focused keepass")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

hs.hotkey.bind(mod, "Y", function()
  -- local win = hs.window.focusedWindow()
  -- win:setFrameInScreenBounds()
  hs.window.focusedWindow():setFrameInScreenBounds()
end)

hs.hotkey.bind(mod, "S", function()
  io.popen("say headphones")
end)

hs.hotkey.bind(mod, "U", function()
  f = io.popen(cmd_dir + "unmount_sd_osx")
  s = f:read('*a')
  hs.alert.show(s)
end)

-- random spotify album
hs.hotkey.bind(mod, "Q", function()
-- another approach would be to have the lua function get both the name and the uri
-- from the python script, then have the lua function use its applescript interface
-- to play the album. not sure if there's any difference

  -- python install is fucked up. changed the hashbang in random_album to a fixed python (with /usr/bin/env)
  -- which works when running on CLI, but not inside hammerspoon
  -- can't figure out how to debug `/usr/bin/env python` inside hammerspoon, 
  -- so just specifying which python to use here.
  -- undo this after reinstalling OS.
    -- f = io.popen("/u/a/venvs/0/bin/python /u/a/cmd/random_album play")
    -- now the workaround is broken (broken homebrew links)
    -- but just executing the python script works if:
    -- #!/usr/local/bin/python

  -- this calls an alias which was $PY/random_spotify_album but is now $PY/random_vlc_album

  --f = io.popen(cmd_dir .. "random_album play")
  out, status, typ, rc = hs.execute(python3 .. " " .. cmd_dir .. "random_album play")
  hs.alert(out)
end)

hs.hotkey.bind(mod, "N", function()
  -- see ctrl-alt-Q
  out, status, typ, rc = hs.execute(python3 .. " " .. cmd_dir .. "random_album new")
  hs.alert(out)

end)




-- all of the below is an attempt at mic mute toggle


--hs.hotkey.bind(mod, "M", function()
    -- io.popen("/u/a/cmd/mute-mic")
--    local currentAudioInput = hs.audiodevice.current(true)
--    local currentAudioInputObject = hs.audiodevice.findInputByUID(currentAudioInput.uid)
--    muted = currentAudioInputObject:inputMuted()
--    currentAudioInputObject:setInputMuted(not muted)
--    hs.alert.show("toggle mute mic")
--end)



-- https://medium.com/@robhowlett/hammerspoon-the-best-mac-software-youve-never-heard-of-40c2df6db0f8
micMuteStatusMenu = hs.menubar.new()
micMuteStatusLine = nil
function displayMicMuteStatus()
    local currentAudioInput = hs.audiodevice.current(true)
    local currentAudioInputObject = hs.audiodevice.findInputByUID(currentAudioInput.uid)
    muted = currentAudioInputObject:inputMuted()
    if muted then
        micMuteStatusMenu:setIcon(os.getenv("HOME") .. "/.hammerspoon/muted.png")
        micMuteStatusLineColor = {["red"]=1,["blue"]=0,["green"]=0,["alpha"]=0.7}
    else
        micMuteStatusMenu:setIcon(os.getenv("HOME") .. "/.hammerspoon/unmuted.png")
        micMuteStatusLineColor = {["red"]=1,["blue"]=0,["green"]=1,["alpha"]=0.7}
    end
    if micMuteStatusLine then
        micMuteStatusLine:delete()
    end
    max = hs.screen.primaryScreen():fullFrame()
    -- micMuteStatusLine = hs.drawing.rectangle(hs.geometry.rect(max.x, max.y, max.w, max.h))
    -- micMuteStatusLine:setStrokeColor(micMuteStatusLineColor)
    -- micMuteStatusLine:setFillColor(micMuteStatusLineColor)
    -- micMuteStatusLine:setFill(false)
    -- micMuteStatusLine:setStrokeWidth(30)
    -- micMuteStatusLine:show()
end
for i,dev in ipairs(hs.audiodevice.allInputDevices()) do
   dev:watcherCallback(displayMicMuteStatus):watcherStart()
end
function toggleMicMuteStatus()
    local currentAudioInput = hs.audiodevice.current(true)
    local currentAudioInputObject = hs.audiodevice.findInputByUID(currentAudioInput.uid)
    currentAudioInputObject:setInputMuted(not muted)
    -- displayMicMuteStatus()
end
displayMicMuteStatus()
hs.hotkey.bind(mod, "M", toggleMicMuteStatus)
micMuteStatusMenu:setClickCallback(toggleMicMuteStatus)
function toggleMicMuteStatusAlert()
    if micMuteStatusAlert then
        micMuteStatusAlert = false
        -- micMuteStatusLine:delete()
    else
        micMuteStatusAlert = true
        displayMicMuteStatus()
    end
end

function clearScreen()
  if micMuteStatusLine then
    micMuteStatusLine:delete()
  end
end

hs.hotkey.bind(mod, "c", clearScreen)




function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
