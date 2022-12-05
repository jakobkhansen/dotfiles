require("lualine").setup({
    options = {
        theme = "tokyonight",
        globalstatus = true,
    },
    sections = {
        lualine_a = { "branch" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
})

