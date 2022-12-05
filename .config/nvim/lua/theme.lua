local vimscript = vim.api.nvim_exec
require("tokyonight").setup({
    comments = { italic = false },
    keywords = { italic = false },

    styles = {
        info = { fg = "#FFFFFF" },
        hint = { fg = "#FFFFFF" },
        warning = { fg = "#FFFFFF" },
        sidebars = "transparent",
    },

    on_highlights = function(hl, c)
        hl.DiagnosticUnderlineError = {
            undercurl = false,
            underline = true,
            sp = c.error,
        }
        hl.DiagnosticUnderlineWarn = {
            undercurl = false,
            underline = true,
            sp = c.warning,
        }
        hl.DiagnosticUnderlineInfo = {
            undercurl = false,
            underline = true,
            sp = c.info,
        }
        hl.DiagnosticUnderlineHint = {
            undercurl = false,
            underline = true,
            sp = c.hint,
        }
    end,
})
vimscript("colorscheme tokyonight", false)

-- Additional highlight group linking
vim.api.nvim_set_hl(0, "StatusLine", {})
