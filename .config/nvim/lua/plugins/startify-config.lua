local vimscript = vim.api.nvim_exec

vim.g.startify_files_number = 5

vim.g.startify_commands = {
	{ "Reload Vim", "luafile $MYVIMRC" },
	{ "Update plugins", "PackerSync" },
	{ "Clean plugins", "PackerClean" },
}

-- Often Used
local function oftenUsed()
	return {
		{ line = " TODO", cmd = "edit $HOME/Documents/TODO.norg" },
		{ line = "Neovim", cmd = "cd $HOME/.config/nvim/" },
		{ line = "Kattis", cmd = "cd $HOME/Documents/Personal/KattisSolutions" },
		{ line = " Timeliste", cmd = "edit $HOME/Documents/School/GRUPPELÆRER/IN2010_2021/timeliste-november.norg" },
	}
end

local function configFiles()
	local files = {
		{ line = "vim", path = "$MYVIMRC" },
		{ line = "bashrc", path = "$HOME/.bashrc" },
		{ line = "bash aliases", path = "$HOME/.bash_aliases" },
		{ line = "i3", path = "$HOME/.config/i3/config" },
		{ line = "ranger", path = "$HOME/.config/ranger/rc.conf" },
		{ line = "kitty", path = "$HOME/.config/kitty/kitty.conf" },
		{ line = "polybar", path = "$HOME/.config/polybar/config" },
		{ line = "compton", path = "$HOME/.config/compton/compton.conf" },
		{ line = "zsh", path = "$HOME/.config/zsh/.zshrc" },
	}

	return files
end

-- Lua config files
local function luaFiles()
	local scan = require("plenary").scandir
	local home = vim.env["HOME"]
	local files = scan.scan_dir(home .. "/.config/nvim/lua")
	out = {}
	for i, v in ipairs(files) do
		out[i] = { line = v, path = v }
	end
	return out
end

vim.g.startify_lists = {
	{ type = "files", header = { "   Recent" } },
	{ type = oftenUsed, header = { "   Often used" }, indices = { "todo", "nv", "ka", "time" } },
	{
		type = configFiles,
		header = { "   Config files" },
		indices = { "cv", "cb", "ca", "ci", "cr", "ck", "cp", "co", "cz" },
	},
	{ type = "commands", header = { "   Commands" }, indices = { "cs", "pu", "pc" } },
	{ type = luaFiles, header = { "   Lua config files" } },
}
