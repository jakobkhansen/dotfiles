require("mini.bufremove").setup()

require("mini.comment").setup()

require("mini.pairs").setup({
    mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = ".[^%w]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = ".[^%w]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[^%w]" },

        -- I think this could be changed to only run for Rust with MiniPairs.map_buf or MiniPairs.map
        ["'"] = { action = "open", pair = "''", neigh_pattern = "[^&|<]." },
    },
})

require("mini.surround").setup({
    mappings = {
        add = "ss",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
    },
})
