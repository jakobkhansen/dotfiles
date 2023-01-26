-- Ensure colorscheme is already loaded
require("theme")

require("bufferline").setup({
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = { "", "" },
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
            local icon = level:match("error") and (" " .. count) or ""
            return "" .. icon
        end,
    },
})
