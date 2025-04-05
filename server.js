const fs = require('fs').promises;

exports("readDir", async function(dir) {
    try {
        const files = await fs.readdir(dir, { withFileTypes: true });
        return {
            data: files.map(dirent => ({
                name: dirent.name,
                isDir: dirent.isDirectory()
            }))
        };
    } catch (error) {
        console.error(`[Cipher] Directory read error: ${error.message}`);
        return { error: error.message };
    }
});