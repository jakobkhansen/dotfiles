local dap = require("dap")
local autocmd = vim.api.nvim_create_autocmd

dap.adapters.netcoredbg = {
    type = 'executable',
    command =
    'C:\\Users\\jakobhansen\\Documents\\netcoredbg\\netcoredbg.exe',
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
