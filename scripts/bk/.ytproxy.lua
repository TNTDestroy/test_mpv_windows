local function init()
    local url = mp.get_property("stream-open-filename")
    if not url then return end -- Kiểm tra an toàn
    
    -- Chỉ kích hoạt khi là link YouTube (https hoặc youtu)
    if url:find("^https:") == nil or url:find("youtu") == nil then
        return
    end

    -- Nếu đã có proxy khác thì không can thiệp
    local proxy = mp.get_property("http-proxy")
    if proxy and proxy ~= "" and proxy ~= "http://127.0.0.1:12081" then
        return
    end

    -- === TỰ ĐỘNG NHẬN DIỆN HỆ ĐIỀU HÀNH ===
    local script_dir = mp.get_script_directory()
    -- Kiểm tra dấu phân cách thư mục: Windows dùng '\', Linux/Mac dùng '/'
    local is_windows = (package.config:sub(1,1) == "\\")
    
    -- Chọn tên file chạy tương ứng
    local binary_name = "http-ytproxy" -- Mặc định cho Linux/macOS
    if is_windows then
        binary_name = "http-ytproxy.exe" -- Thêm đuôi .exe cho Windows
    end
    
    -- Tạo đường dẫn tuyệt đối tới thư mục con 'ytproxy'
    -- (Dùng '/' là an toàn nhất cho cả Windows trong Lua)
    local bin_path = script_dir .. "/ytproxy/" .. binary_name
    local cert_path = script_dir .. "/ytproxy/cert.pem"
    local key_path = script_dir .. "/ytproxy/key.pem"
    -- ======================================

    -- Chạy proxy
    local args = {
        bin_path,
        "-c", cert_path,
        "-k", key_path,
        "-r", "10485760", -- range modification
        "-p", "12081"     -- proxy port
    }
    
    mp.command_native_async({
        name = "subprocess",
        capture_stdout = false,
        playback_only = false,
        args = args,
    });

    -- Cấu hình mpv sử dụng proxy này
    mp.set_property("http-proxy", "http://127.0.0.1:12081")
    mp.set_property("tls-verify", "no")
end

mp.register_event("start-file", init)