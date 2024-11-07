local signatures = {
    [[\x68\x65\x6c\x70\x43\x6f\x64\x65]],
    [[\x61\x73\x73\x65\x72\x74]],
    [[\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74]],
    [[\x50\x65\x72\x66\x6F\x72\x6D\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74]]
}

local currentRes = GetCurrentResourceName()

-- GetResources function
local function GetResources()
    local resourceList = {}
    for i = 0, GetNumResources() - 1 do
        local resource_name = GetResourceByFindIndex(i)
        if resource_name and GetResourceState(resource_name) == "started" and resource_name ~= "_cfx_internal" and resource_name ~= currentRes then
            table.insert(resourceList, resource_name)
        end
    end
    return resourceList
end

local function FileExt(filename)
    local extension = string.match(filename, "%.([^%.]+)$")
    if extension then
        return extension
    else
        return false
    end
end

local function sanitizePath(path)
    -- Remove double slashes
    path = path:gsub("//", "/")
    -- Remove trailing slash
    if path:sub(-1) == "/" then
        path = path:sub(1, -2)
    end
    return path
end

local function ScanDir(resource_name, res_directory, folder_files)
    local dir = sanitizePath(res_directory .. "/" .. folder_files)
    
    -- Read directory with error handling
    local result = exports[GetCurrentResourceName()]:readDir(dir)
    if not result.success then
        print("^1[CipherScanner] Error reading directory: " .. dir .. " - " .. tostring(result.error) .. "^7")
        return
    end

    local lof_directory = result.data
    for index = 1, #lof_directory do
        local file_name = lof_directory[index]
        local file_path = sanitizePath(dir .. "/" .. file_name)
        
        -- Check if path is directory with error handling
        local is_dir_result = exports[GetCurrentResourceName()]:isDir(file_path)
        if not is_dir_result.success then
            print("^3[CipherScanner] Warning: Cannot check if directory: " .. file_path .. " - " .. tostring(is_dir_result.error) .. "^7")
            goto continue
        end

        if not is_dir_result.data then
            -- File processing
            pcall(function()
                local relative_path = folder_files .. "/" .. file_name
                local file_content = LoadResourceFile(resource_name, relative_path)
                
                if file_content then
                    if FileExt(file_name) == "lua" then
                        for i = 1, #signatures do
                            if file_content:find(signatures[i]) then
                                print("^2[CipherScanner] Found cipher pattern inside resource: " .. resource_name .. ", file: " .. relative_path .. "^7")
                            end
                        end
                    end
                else
                    print("^3[CipherScanner] Warning: Cannot read file: " .. relative_path .. "^7")
                end
            end)
        elseif file_name ~= "node_modules" and file_name ~= "stream" and file_name ~= "." and file_name ~= ".." then
            -- Recursive directory scanning
            ScanDir(resource_name, res_directory, folder_files .. "/" .. file_name)
        end
        
        ::continue::
    end
end

local function InitCipherScanner()
    print("^4[CipherScanner] Starting scan of resources^7")

    local Resources = GetResources()
    for i = 1, #Resources do
        local resource_name = Resources[i]
        local res_directory = sanitizePath(GetResourcePath(resource_name))
        
        -- Read directory with error handling
        local result = exports[GetCurrentResourceName()]:readDir(res_directory)
        if not result.success then
            print("^1[CipherScanner] Error reading resource directory: " .. res_directory .. " - " .. tostring(result.error) .. "^7")
            goto continue
        end

        local lof_directory = result.data
        for index = 1, #lof_directory do
            local file_name = lof_directory[index]
            local file_path = sanitizePath(res_directory .. "/" .. file_name)
            
            -- Check if path is directory with error handling
            local is_dir_result = exports[GetCurrentResourceName()]:isDir(file_path)
            if not is_dir_result.success then
                print("^3[CipherScanner] Warning: Cannot check if directory: " .. file_path .. " - " .. tostring(is_dir_result.error) .. "^7")
                goto continue_inner
            end

            if not is_dir_result.data then
                pcall(function()
                    local file_content = LoadResourceFile(resource_name, file_name)
                    if file_content then
                        if FileExt(file_name) == "lua" then
                            for i = 1, #signatures do
                                if file_content:find(signatures[i]) then
                                    print("^2[CipherScanner] Found cipher pattern inside resource: " .. resource_name .. ", file: " .. file_name .. "^7")
                                end
                            end
                        end
                    end
                end)
            elseif file_name ~= "node_modules" and file_name ~= "stream" then
                ScanDir(resource_name, res_directory, file_name)
            end
            
            ::continue_inner::
        end
        
        ::continue::
    end
    print("^4[CipherScanner] Finished scanning resources^7")
end

-- Start the scanner
CreateThread(function()
    Wait(1000) -- Give more time for resources to load
    InitCipherScanner()
end)