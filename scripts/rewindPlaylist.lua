-- -----------------------------------------------------------
--
-- rewindPlaylist.lua
-- Version: 
-- Author: bitingsock
-- URL: 
-- https://gist.github.com/bitingsock/0f22c631295273d5a53e4337c25fe161
--
-- Description:
--
--  keybind to rewind to the end of the previous playlist entry
--
-- -----------------------------------------------------------
local optStart = 0
function seekHandler(duration)
    if mp.get_property_number("playlist-pos") > 0 then
        optStart = mp.get_property("start")
        mp.set_property("start", duration)
        mp.command("playlist-prev")
    end
end
mp.register_event("file-loaded", function() mp.set_property("start", optStart) end)

mp.add_key_binding("Ctrl+left","rewindPlaylist",function() seekHandler(-5) end)