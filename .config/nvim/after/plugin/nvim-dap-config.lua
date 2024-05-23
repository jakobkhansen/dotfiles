local dap = require("dap")
local autocmd = vim.api.nvim_create_autocmd

dap.adapters.coreclr = {
    type = 'executable',
    command =
    'C:\\Users\\jakobhansen\\Documents\\netcoredbg\\netcoredbg.exe',
    args = { '--interpreter=vscode' }
}

dap.adapters.netcoredbg = {
    type = 'executable',
    command =
    'C:\\Users\\jakobhansen\\Documents\\netcoredbg\\netcoredbg.exe',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "attach - netcoredbg",
        request = "attach",
        processId = function()
            return require("dap.utils").pick_process({
                filter = function(process)
                    return process.name == "Microsoft.Loki.Service.exe"
                end
            })
        end
    },
}

autocmd("FileType", {
    pattern = { "dap-float" },
    command = "setlocal relativenumber"
})
