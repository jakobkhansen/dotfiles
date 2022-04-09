local command = vim.api.nvim_command
local vimscript = vim.api.nvim_exec
local add_command = vim.api.nvim_add_user_command

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

function P.LightMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Day")
	vim.o.background = "light"
	vimscript("colorscheme tokyonight", false)
end

function P.DarkMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Storm")
	vim.o.background = "dark"
	vimscript("colorscheme tokyonight", false)
end

function P.ToggleThemeMode()
	if vim.o.background == "dark" then
		P.LightMode()
	else
		P.DarkMode()
	end
end

add_command("LightMode", P.LightMode, {})
add_command("DarkMode", P.DarkMode, {})

return P
