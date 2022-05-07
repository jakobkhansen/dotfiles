local utils = require("utils")
local command = vim.api.nvim_command
local execute = vim.api.nvim_exec

local P = {}

require("timetrap_nvim").setup({
	display = {
		win_type = "float",
		border = "rounded",
	},
	prompts = "float",
})

function P.check_in()
	utils.showFloatingPrompt("Check into task:", function(result)
		command("Timetrap in " .. result)
	end, function() end)
end

return P
