require("snacks").setup({
    rename = { enabled = true },
    picker = {
        enabled = true,
        layout = {
            reverse = true,
            hidden = { "preview" },
            layout = {
                box = "horizontal",
                backdrop = true,
                width = 0.8,
                height = 0.9,
                border = "none",
                {
                    box = "vertical",
                    { win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
                    { win = "input", height = 1,          border = "rounded",   title = "{title} {live} {flags}", title_pos = "center" },
                },
                {
                    win = "preview",
                    title = "{preview:Preview}",
                    width = 0.45,
                    border = "rounded",
                    title_pos = "center",
                },
            },
        },
        win = {
            input = {
                keys = {
                    ["<C-p>"] = { "toggle_preview", mode = { "i", "n" } }
                }
            }
        }
    },
})
