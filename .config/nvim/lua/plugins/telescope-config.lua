local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local fb_actions = require("telescope").extensions.file_browser.actions
local fb_utils = require("telescope._extensions.file_browser.utils")
local fb_picker = require("telescope._extensions.file_browser.picker")
local action_set = require("telescope.actions.set")
local state = require("telescope.state")
local builtin = require("telescope.builtin")
local fb_finders = require("telescope._extensions.file_browser.finders")

local lastDirectory

local get_target_dir = function(finder)
	local entry_path
	if finder.files == nil then
		return lastDirectory or vim.fn.getcwd()
	elseif finder.files == false then
		local entry = action_state.get_selected_entry()
		entry_path = entry and entry.value -- absolute path
	end
	lastDirectory = finder.files and finder.path or entry_path
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

local open_file_browser = function(files)
	return function(prompt_bufnr)
		local current_picker = action_state.get_current_picker(prompt_bufnr)
		local curr_finder = current_picker.finder
		local dir = get_target_dir(curr_finder)
		print(dir)
		vim.cmd(
			"Telescope file_browser hide_parent_dir=true, cwd_to_path=true path=" .. dir .. " files=" .. tostring(files)
		)
	end
end

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

local goto_parent_dir_check = function()
	return function(prompt_bufnr)
		local current_picker = action_state.get_current_picker(prompt_bufnr)
		if current_picker ~= nil then
			local curr_finder = current_picker.finder
			if curr_finder ~= nil and curr_finder.files ~= nil then
				fb_actions.goto_parent_dir(prompt_bufnr)
			end
		end
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
				["<BS>"] = goto_parent_dir_check(),

				["<A-f>"] = open_in(builtin.find_files, {}),
				["<A-g>"] = open_in(builtin.git_files, {}),
				["<A-d>"] = open_file_browser(false),
				["<A-b>"] = open_file_browser(true),
				["o"] = open_xdg(),
			},
			i = {
				["<A-f>"] = open_in(builtin.find_files, {}),
				["<A-g>"] = open_in(builtin.git_files, {}),
				["<A-d>"] = open_file_browser(false),
				["<A-b>"] = open_file_browser(true),
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
		file_browser = {
			mappings = {
				n = {
					["o"] = fb_actions.open,
				},
			},
		},
		heading = {
			treesitter = true,
		},
	},
})


require("telescope").load_extension("fzf")
require("telescope").load_extension("termfinder")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("heading")

local P = {}

function P.config_files(opts)
    local nvim_files = vim.split(vim.fn.glob('~/.config/nvim/lua/*/*lua'), '\n')
    local config_files = {
        vim.env.HOME .. "/.config/nvim/init.lua",
        vim.env.HOME .. "/.config/i3/config",
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
