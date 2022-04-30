require("bufferline").setup({
	options = {
		numbers = "none",
		close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"

		indicator_icon = "▎",
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",

		max_name_length = 25,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		tab_size = 15,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,

		show_buffer_close_icons = false,
		show_close_icon = false,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = {'', ''},
        always_show_bufferline = false
	},
})
