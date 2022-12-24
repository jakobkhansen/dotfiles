local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername

require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    ignore_install = { "phpdoc" },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = { "python", "cpp", "lex", "java" },
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

-- Master
ft_to_parser.mdx = "markdown"
