# 🔐 FiveM Cipher Scanner v2.0
**Enterprise-grade security scanning for FiveM servers**  
*Detect backdoors, malicious code, and suspicious patterns in real-time*

---

## 🚀 Features
### 🔍 Advanced Detection
- **7 built-in security patterns** covering critical threats
- **Unlimited custom patterns** via config
- **Multi-level severity** (Critical/High/Medium/Warning)

**Default Detections**:
```lua
-- Critical
{pattern = "helpCode", severity = "critical"},

-- High Risk 
{pattern = "Inject%s*%(", severity = "high"},
{pattern = "assert%s*%(", severity = "high"},
{pattern = "PerformHttpRequest", severity = "high"},

-- Medium Risk
{pattern = "RegisterNetEvent", severity = "medium"},
{pattern = "TriggerServerEvent", severity = "medium"},

-- Warning
{pattern = "\\x%x%x", severity = "warning"}  -- Suspicious hex
```

### 📊 Intelligent Reporting
- **Console Alerts** with verified color-coding
- **Discord Webhook** integration
- Scan statistics & performance metrics

### ⚡ Performance
- Async non-blocking scans
- Configurable concurrency
- Automatic folder exclusions

---

## 🎨 Verified Color System
| Severity  | Color Code | Preview              | Use Case                     |
|-----------|------------|----------------------|------------------------------|
| Critical  | `^1`       | 🔴 Bright Red         | `helpCode`, `Inject()`       |
| High      | `^6`       | 🟠 Orange            | `PerformHttpRequest`         |
| Medium    | `^3`       | 🟡 Yellow            | `RegisterNetEvent`           |
| Warning   | `^5`       | 🟣 Purple            | Suspicious hex (`\x6C`)      |
| Info      | `^4`       | 🔵 Blue              | Scan status messages         |

*Colors match exact console output from your `server.lua`*

---

## 🛠️ Usage
**Automatic Scan**
Runs on server start
Scans all active resources

**Sample Output**
```diff
[14:33] ^4[Cipher]^7 Scan started (v2.0.0)
[14:33] ^1[CRITICAL]^7 helpCode in cfx_utils/client.lua
[14:33] ^6[HIGH]^7 PerformHttpRequest in esx_menu/server.lua
[14:33] ^4[Cipher]^7 Scan completed in 1.8s (1 critical, 3 high)
```
![image](https://github.com/user-attachments/assets/a589e306-19d1-4cd4-b9b7-0432122754fc)

##⚙️ Configuration Guide
**Core Settings**
```lua
Config = {
    Discord = {
        webhook = "https://discord.com/api/webhooks/...",
        username = "Security Alerts"
    },
    ScanSettings = {
        scanDelay = 10, -- Seconds between auto-scans
        skipFolders = {"node_modules", "stream"}
    }
}
```
**Custom Patterns**
```lua
patterns = {
    -- Severity levels: critical/high/medium/warning
    {pattern = "d0g3", severity = "critical"},
    {pattern = "\\x73\\x68\\x61\\x64\\x6F\\x77", severity = "high"}
}
```
---

### ❓ FAQ
## 🛠️ Setup
```markdown
**Q: Custom patterns not working?**  
```lua
-- BAD: Missing regex
{pattern = "Inject(", severity = "high"}  

-- GOOD: Escaped pattern  
{pattern = "Inject%s*%(", severity = "high"}
```

#### 🚦 Performance  
**Q: Files being skipped?**  
```lua
-- Default exclusions (config.lua)
skipFolders = {"node_modules", "stream"}  -- Add/remove as needed
```

**Q: Change colors?**  
```lua
-- config.lua override
colors = {
    critical = 16711680,  -- ^1 Red
    high = 65280          -- ^2 Green
}
```

#### 🔍 Detection  
**Q: Whitelist patterns?**  
```lua
exclusions = {
    "RegisterNetEvent%(.*%)",  -- Ignore all event reg
    "author = 'trustedDev'"    -- Safe-file marker
}
```