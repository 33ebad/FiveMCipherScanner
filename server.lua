local currentRes = GetCurrentResourceName()
print(("^2[%s] INITIALIZED^7"):format(currentRes))

-- ========================
-- CONFIGURATION
-- ========================
local Config = {
    ScanSettings = {
        patterns = {
            -- Ordered by severity
            {name = "NetEvent", pattern = "RegisterNetEvent", color = "^6", severity = "MEDIUM"},
            {name = "HttpRequest", pattern = "PerformHttpRequest", color = "^3", severity = "HIGH"},
            {name = "assert()", pattern = "assert%s*%(", color = "^3", severity = "HIGH"},
            {name = "helpCode", pattern = "helpCode", color = "^1", severity = "CRITICAL"}
        },
        skipFolders = {"node_modules", "stream", "vendor"}
    }
}

-- ========================
-- SCANNING SYSTEM
-- ========================
local detections = {}
local stats = {}

-- Initialize stats
for _, pat in ipairs(Config.ScanSettings.patterns) do
    stats[pat.name] = {count = 0, severity = pat.severity, color = pat.color}
end

local function ScanFile(resource, path)
    local content = LoadResourceFile(resource, path)
    if not content or content:gsub("%s", "") == "" then return end

    local fileDetections = {}
    for _, pat in ipairs(Config.ScanSettings.patterns) do
        if content:find(pat.pattern) then
            table.insert(fileDetections, pat)
            stats[pat.name].count = stats[pat.name].count + 1
        end
    end

    if #fileDetections > 0 then
        table.insert(detections, {
            resource = resource,
            file = path,
            patterns = fileDetections
        })
    end
end

local function ScanResource(resource)
    local path = GetResourcePath(resource)
    if not path then return end

    local result = exports[currentRes]:readDir(path)
    if not result or not result.data then return end

    for _, entry in ipairs(result.data) do
        if not entry.isDir and entry.name:match("%.lua$") then
            ScanFile(resource, entry.name)
        end
    end
end

-- ========================
-- REPORT GENERATION
-- ========================
local function GenerateReport()
    -- Detailed Findings First
    if #detections > 0 then
        print("\n^4========= DETECTION DETAILS =========^7")
        for _, det in ipairs(detections) do
            local patternText = {}
            for _, pat in ipairs(det.patterns) do
                table.insert(patternText, pat.color..pat.name.."^7")
            end
            print(("%s/%s: %s"):format(
                det.resource,
                det.file,
                table.concat(patternText, ", ")
            ))
        end
        print("^3===================================^7")
    else
        print("\n^2No malicious patterns detected^7")
    end

    -- Summary Report Last
    print("\n^3============ SCAN SUMMARY ============^7")
    -- Print in severity order: MEDIUM -> HIGH -> CRITICAL
    for _, severity in ipairs({"MEDIUM", "HIGH", "CRITICAL"}) do
        for _, pat in ipairs(Config.ScanSettings.patterns) do
            if pat.severity == severity then
                local stat = stats[pat.name]
                print(("%s%-12s %-8s: %s%d detection(s)^7"):format(
                    stat.color,
                    pat.name,
                    "("..stat.severity..")",
                    stat.count > 0 and "^2" or "^1",
                    stat.count
                ))
            end
        end
    end
    print("^3===================================^7")
end

-- ========================
-- MAIN PROCESS
-- ========================
CreateThread(function()
    print(("^4[%s] SCAN STARTED^7"):format(currentRes))
    local startTime = os.clock()

    -- Reset trackers
    detections = {}
    for _, pat in ipairs(Config.ScanSettings.patterns) do
        stats[pat.name].count = 0
    end

    -- Scan all resources
    for i = 0, GetNumResources()-1 do
        local res = GetResourceByFindIndex(i)
        if res and res ~= currentRes and GetResourceState(res) == "started" then
            ScanResource(res)
        end
    end

    -- Generate final report
    GenerateReport()
    print(("\n^4[%s] SCAN COMPLETED IN %.3f SECONDS^7"):format(
        currentRes, os.clock() - startTime
    ))
end)