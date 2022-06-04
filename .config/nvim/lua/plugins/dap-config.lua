local dap = require("dap")
local telescope = require("plugins.telescope-config")

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = vim.env.HOME .. "/.langservers/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}
