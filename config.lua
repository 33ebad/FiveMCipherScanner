Config = {
    Discord = {
        webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
        colors = {
            critical = 16711680,    -- Red
            high = 16744192,        -- Orange
            medium = 16776960,      -- Yellow
            warning = 10181046      -- Purple
        },
        username = "Cipher Scanner",
        avatar = "https://i.imgur.com/6h7CqJG.png",
        enable = true
    },

    ScanSettings = {
        patterns = {
            {pattern = "helpCode", severity = "critical"},
            {pattern = "Inject%s*%(", severity = "critical"},
            {pattern = "assert%s*%(", severity = "high"},
            {pattern = "PerformHttpRequest", severity = "high"},
            {pattern = "RegisterNetEvent", severity = "medium"},
            {pattern = "TriggerServerEvent", severity = "medium"},
            {pattern = "\\x%x%x", severity = "warning"}
        },
        scanDelay = 10,
        maxConcurrent = 2,
        skipFolders = {"node_modules", "stream"}
    }
}
return Config