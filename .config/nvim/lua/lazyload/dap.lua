local dap = require("dap")
local autocmd = vim.api.nvim_create_autocmd
local home = vim.loop.os_homedir()
local utils = require("utils")

if utils.isWindows() then
    dap.listeners.before.initialize["netcoredbg.windows-paths"] = function(session)
        if session.config.type ~= "netcoredbg" then
            return
        end

        local request = session.request
        session.request = function(self, command, arguments, on_result)
            -- Netcoredbg needs native PDB paths even when buffers use forward slashes.
            if command == "setBreakpoints" and arguments.source and arguments.source.path then
                arguments.source.path = arguments.source.path:gsub("/", "\\")
            end
            return request(self, command, arguments, on_result)
        end
    end
end

dap.adapters.netcoredbg = {
    type = 'executable',
    command =
        vim.fs.joinpath(home, 'Documents', 'netcoredbg', utils.isWindows() and 'netcoredbg.exe' or 'netcoredbg'),
    args = { '--interpreter=vscode' }
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
