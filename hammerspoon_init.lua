-- http://www.hammerspoon.org/go/
-- global keyboard shortcuts:
-- cmd+alt+ctrl+W   hello world (popup notification)
-- ctrl-alt-S       headphones (spoken) - for testing whether headphone jack is broken
-- ctrl-alt-U       unmount SD card (ad-hoc)
-- ctrl-alt-Q       play random spotify album
-- ctrl-alt-P       launch/focus keepass


hs.hotkey.bind({"ctrl", "alt"}, "P", function()
  hs.application.launchOrFocus("KeePassX")
  hs.alert.show("launched or focused keepass")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

hs.hotkey.bind({"ctrl", "alt"}, "S", function()
  io.popen("say -v Zarvox headphones")
end)

hs.hotkey.bind({"ctrl", "alt"}, "U", function()
  f = io.popen("/u/a/cmd/unmount_sd_osx")
  s = f:read('*a')
  hs.alert.show(s)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Q", function()
-- another approach would be to have the lua function get both the name and the uri
-- from the python script, then have the lua function use its applescript interface
-- to play the album. not sure if there's any difference

  f = io.popen("/u/a/cmd/random_album play")
  s = f:read('*a')
  hs.alert.show(s) -- handled by spotify-notifications app, or whatever its called
end)