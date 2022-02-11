local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local command = vim.api.nvim_command
local fb_actions = require("telescope").extensions.file_browser.actions

require("telescope").setup({
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
				["n"] = {
					["<Esc>"] = function(prompt_bufnr)
						local get_target_dir = function(finder)
							local entry_path
							if finder.files == false then
								local entry = action_state.get_selected_entry()
								entry_path = entry and entry.value -- absolute path
							end
							return finder.files and finder.path or entry_path
						end

						local current_picker = action_state.get_current_picker(prompt_bufnr)
						local finder = current_picker.finder
                        local dir = get_target_dir(finder)
                        if dir ~= nil then
                            vim.cmd("cd" .. get_target_dir(finder))
                        end
                        require("telescope.actions").close(prompt_bufnr)

                        return true
					end,
                    ["<BS>"] = fb_actions.goto_parent_dir
				},
			},
		},
	},
	defaults = {
		file_ignore_patterns = { "%.class" },
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("termfinder")
require("telescope").load_extension("file_browser")

