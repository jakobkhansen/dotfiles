local truncateDir = function()
	local num_dirs = 3
	local dir = vim.fn.getcwd()
	local truncated = ""
	local dirs = {}
	for str in string.gmatch(dir, "([^/]+)") do
		table.insert(dirs, str)
	end

	for i = #dirs, 1, -1 do
		value = dirs[i]
		truncated = value .. "/" .. truncated
		num_dirs = num_dirs - 1
		if num_dirs <= 0 then
			break
		end
	end

	return truncated
end

require("lualine").setup({
	options = {
		theme = "tokyonight",
		globalstatus = true,
	},
	sections = {
		lualine_a = { "branch" },
		lualine_b = { { "filename", path = 1 } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{
				truncateDir,
			},
		},
		lualine_z = {},
	},
})
