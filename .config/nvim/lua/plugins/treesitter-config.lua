local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername

parser_configs.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
    },
}

parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main",
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main",
    },
}

require("nvim-treesitter.configs").setup({
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "phpdoc" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org" },
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
    textsubjects = {
        enable = true,
        keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
        },
    },
})

-- Master
ft_to_parser.ccdetect = "java"
ft_to_parser.mdx = "markdown"
