🔒 **Enhanced Cipher Scanner**

A robust FiveM resource scanner that helps protect your server from malicious code patterns, backdoors, and potentially harmful scripts. 🛡️

---

**Features** ✨

- ⚙️ Enhanced error handling and reporting
- 🌈 Colored console output for better visibility
- 🔄 Recursive directory scanning
- 🛑 Intelligent path sanitization
- 🚫 Excluded directories (node_modules, stream)
- 📊 Detailed scanning feedback
- 🔍 Support for multiple signature patterns

---

**Installation** 📝

1. 🔽 Download the latest release
2. 📂 Extract the files to your resources folder
3. ✨ Rename the folder to `svr_FiveMCipherScanner`
4. ➕ Add `ensure svr_FiveMCipherScanner` to your `server.cfg`
5. 🔄 Restart your server

---

**Usage** 🛠️

The scanner automatically runs when the resource starts. It will:

- 🔍 Scan all running resources
- 🧐 Check for suspicious code patterns
- 📢 Report findings in the server console with color-coded messages
- 📑 Provide detailed information about scan results

---

**Console Output Colors** 🎨

- 🟦 **Blue**: Information messages
- 🟩 **Green**: Found patterns
- 🟨 **Yellow**: Warnings
- 🟥 **Red**: Errors

---

**Security Patterns Detected** 🚨

The scanner looks for several potentially malicious patterns including:

- 🔐 Cipher-specific code
- ⚠️ Suspicious assertions
- 🌐 Unauthorized network events
- 🚨 Suspicious HTTP requests
