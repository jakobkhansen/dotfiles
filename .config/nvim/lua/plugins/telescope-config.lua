local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local open_xdg = function()
	return function(prompt_bufnr)
		local entry = action_state.get_selected_entry()
		local cmd = "xdg-open"
		local path = entry["cwd"] .. "/" .. entry[1]
		require("plenary.job")
			:new({
				command = cmd,
				args = { path },
			})
			:start()
		require("telescope.actions").close(prompt_bufnr)
	end
end


require("telescope").setup({
	defaults = {
		mappings = {
			n = {
				["o"] = open_xdg(),
			},
		},
	},
	file_ignore_patterns = { "%.class" },
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		heading = {
			treesitter = true,
		},
	},
})


require("telescope").load_extension("fzf")
require("telescope").load_extension("termfinder")
require("telescope").load_extension("heading")

local P = {}

function P.config_files(opts)
    local nvim_files = vim.split(vim.fn.glob('~/.config/nvim/lua/**/*lua'), '\n')
    local config_files = {
        vim.env.HOME .. "/.config/nvim/init.lua",
        vim.env.HOME .. "/.config/i3/config",
        vim.env.HOME .. "/.config/ranger/rc.conf",
        vim.env.HOME .. "/.config/ranger/rc.conf",
        vim.env.HOME .. "/.config/zathura/zathurarc",
        vim.env.HOME .. "/.config/kitty/kitty.conf",
        vim.env.HOME .. "/.config/polybar/config",
        vim.env.HOME .. "/.config/compton/compon.conf",
    }

    for i,file in ipairs(nvim_files) do
        table.insert(config_files, file)
    end


	pickers.new(opts, {
	    prompt_title = "Configuration files",
	    finder = finders.new_table {
            results = config_files
        },
	    sorter = conf.generic_sorter(opts),
	}):find()
end

P.genericPicker = function(title, command, on_select, opts)
	opts = opts or {}
	return pickers.new(opts, {
		prompt_title = title,
		finder = finders.new_oneshot_job(vim.split(command, " "), opts),
		previewer = conf.file_previewer(opts),
		sorter = conf.file_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				on_select(selection)
			end)
			return true
		end,
	})
end

return P
