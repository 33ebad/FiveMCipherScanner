const fs = require("fs")

exports("readDir", function(dir) {
    if (GetInvokingResource() == GetCurrentResourceName()) {
        try {
            return {
                success: true,
                data: fs.readdirSync(dir)
            }
        } catch (error) {
            return {
                success: false,
                error: error.message
            }
        }
    }
    return { success: false, error: "Invalid resource call" }
})

exports("isDir", function(path) {
    if (GetInvokingResource() == GetCurrentResourceName()) {
        try {
            const stats = fs.statSync(path);
            return {
                success: true,
                data: stats.isDirectory()
            }
        } catch (error) {
            return {
                success: false,
                error: error.message
            }
        }
    }
    return { success: false, error: "Invalid resource call" }
})