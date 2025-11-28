local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    ignore_install = { "systemverilog", "norg", "ipkg" },
    highlight = {
        enable = true,
        disable = { "latex" },
    },
    indent = {
        enable = false,
        disable = { "python", "cpp", "lex", "java", "tex", "scss", "typescript", "typescriptreact" },
    },
    autotag = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["ac"] = "@call.outer",
                ["ic"] = "@call.inner",
            },
        },
        swap = {
            enable = true,
        },
    },
})
