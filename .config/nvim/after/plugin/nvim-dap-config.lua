local dap = require("dap")
local autocmd = vim.api.nvim_create_autocmd
local home = vim.loop.os_homedir()
local utils = require("utils")

dap.adapters.netcoredbg = {
    type = 'executable',
    command =
        vim.fs.joinpath(home, 'Documents', 'netcoredbg', utils.isWindows() and 'netcoredbg.exe' or 'netcoredbg'),
    args = { '--interpreter=vscode', '--log=file', '--engineLogging=./engineLog.txt' }
}

dap.configurations.cs = {
    {
        type = "netcoredbg",
        name = "attach - netcoredbg",
        request = "attach",
        processId = function()
            return require("dap.utils").pick_process({
                filter = function(process)
                    return true
                end
            })
        end
    },
}

autocmd("FileType", {
    pattern = { "dap-float" },
    command = "setlocal relativenumber"
})
