require("mini.bufremove").setup()

require("mini.comment").setup()

require("mini.pairs").setup({
    mappings = {
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\|<|&]." },
    },
})

require("mini.surround").setup({
    mappings = {
        add = "ss",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",      -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
    },
})
