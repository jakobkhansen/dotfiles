local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local command = vim.api.nvim_command
local fb_actions = require("telescope").extensions.file_browser.actions
local fb_utils = require("telescope._extensions.file_browser.utils")
local fb_picker = require("telescope._extensions.file_browser.picker")
local action_set = require("telescope.actions.set")
local state = require("telescope.state")
local builtin = require("telescope.builtin")
local fb_finders = require("telescope._extensions.file_browser.finders")

local get_target_dir = function(finder)
	local entry_path
	if finder.files == false then
		local entry = action_state.get_selected_entry()
		entry_path = entry and entry.value -- absolute path
	end
	return finder.files and finder.path or entry_path
end

local open_in = function(finder, opts)
	return function(prompt_bufnr)
		local current_picker = action_state.get_current_picker(prompt_bufnr)
		local curr_finder = current_picker.finder
		local dir = get_target_dir(curr_finder)
		opts.cwd = dir
		finder(opts)
	end
end

require("telescope").setup({
	defaults = {
		mappings = {
			n = {

				["<Esc>"] = function(prompt_bufnr)
					local current_picker = action_state.get_current_picker(prompt_bufnr)
					local finder = current_picker.finder
					local dir = get_target_dir(finder)
					if dir ~= nil then
						vim.cmd("cd" .. get_target_dir(finder))
					end
					require("telescope.actions").close(prompt_bufnr)

					return true
				end,
				["<BS>"] = fb_actions.goto_parent_dir,

				["<A-f>"] = open_in(builtin.find_files, {}),
				["<A-d>"] = open_in(fb_picker, { files = false, hide_parent_dir=true, cwd_to_path=true }),
				["<A-b>"] = open_in(fb_picker, { hide_parent_dir=true, cwd_to_path=true }),
			},
			i = {
				["<A-f>"] = open_in(builtin.find_files, {}),
				["<A-d>"] = open_in(fb_picker, { files = false, hide_parent_dir=true, cwd_to_path=true }),
				["<A-b>"] = open_in(fb_picker, { hide_parent_dir=true, cwd_to_path=true }),
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
		file_browser = {},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("termfinder")
require("telescope").load_extension("file_browser")
