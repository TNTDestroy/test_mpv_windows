local inited = 0

-- Hàm kiểm tra Windows chuẩn xác
local function platform_is_windows()
    local platform = mp.get_property_native("platform")
    return platform == "windows"
end

-- Hàm lấy tên hệ điều hành
local function getOS()
    -- Lỗi 1 đã sửa: Chỉ cần kiểm tra true/false
    if platform_is_windows() then
        return "Windows"
    end
    
    local BinaryFormat = package.cpath or ""
    if BinaryFormat:match("dll$") then
        return "Windows"
    elseif BinaryFormat:match("so$") then
        if BinaryFormat:match("homebrew") then
            return "MacOS"
        else
            return "Linux"
        end
    elseif BinaryFormat:match("dylib$") then
        return "MacOS"
    end
    return "Linux" -- Fallback mặc định
end

local function init()
    if inited == 0 then
        local url = mp.get_property("stream-open-filename")
        if not url then return end
        
        -- Check link YouTube
        if url:find("^https:") == nil or url:find("youtu") == nil then
            return
        end
    
        local proxy = mp.get_property("http-proxy")
        if proxy and proxy ~= "" and proxy ~= "http://127.0.0.1:12081" then
            return
        end

        local osv = getOS() -- Lấy hệ điều hành vào biến osv
        local args = nil
        local script_dir = mp.get_script_directory()

        -- Lỗi 2 đã sửa: So sánh biến 'osv' chứ không phải hàm 'getOS'
        if osv == 'Windows' then  
            -- Windows: Dùng .exe
            args = {
                script_dir .. "/http-ytproxy.exe",
                "-c", script_dir .. "/cert.pem",
                "-k", script_dir .. "/key.pem",
                "-r", "10485760",
                "-p", "12081"
            }
        elseif osv == 'MacOS' then  
            -- MacOS: Sửa lỗi typo gạch dưới (_) thành gạch ngang (-)
            args = {
                script_dir .. "/http-ytproxy",
                "-c", script_dir .. "/cert.pem",
                "-k", script_dir .. "/key.pem",
                "-r", "10485760",
                "-p", "12081"
            }
        else
            -- Linux
            args = {
                script_dir .. "/http-ytproxy",
                "-c", script_dir .. "/cert.pem",
                "-k", script_dir .. "/key.pem",
                "-r", "10485760",
                "-p", "12081"
            }
        end
    
        if args then
            mp.command_native_async({
                name = "subprocess",
                capture_stdout = false,
                playback_only = false,
                args = args,
            });
            inited = 1
        end
    end
    
    mp.set_property("http-proxy", "http://127.0.0.1:12081")
    mp.set_property("tls-verify", "no")
end

mp.register_event("start-file", init)