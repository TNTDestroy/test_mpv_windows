local msg = require 'mp.msg'

local function ytdlWatch()
    local path = mp.get_property("path", "")
    -- Use this website to escape LUA String Path (about:support -> Open Profile Folder -> Copy -> Paste): https://onlinestringtools.com/escape-string
    -- Then replace D:\\PB\\Data\\profilet with yours
    local ffpath = "firefox:C:\\Users\\Dung Tran\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\by0l8vjy.Default User"
    local command = { "yt-dlp", "--cookies-from-browser", ffpath, "--mark-watched", "-vU", "--simulate", path }
    local ret = mp.command_native({
        name = "subprocess",
        args = command,
        capture_stdout = true,
        capture_stderr = true
    })
    --msg.info(ret.stdout)
    --msg.info(ret.stderr)
end

--mp.register_event("start-file", ytdlWatch)
mp.register_event("file-loaded", ytdlWatch)