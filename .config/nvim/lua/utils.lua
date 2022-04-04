local command = vim.api.nvim_command

local P = {}

function P.CWDgitRoot()
    local cwd = vim.loop.cwd()
	local git_root = require("lspconfig").util.root_pattern(".git")(cwd)

	if git_root ~= nil then
		local cd_command = "cd " .. git_root
		command(cd_command)
	else
		print("Not a git repository")
	end
end

function P.getFirstDayOfCurrentMonth()
	return os.date("%Y") .. "-" .. os.date("%m") .. "-01"
end

return P
