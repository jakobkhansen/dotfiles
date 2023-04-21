require("neorg").setup({
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    gtd = "~/Documents/gtd",
                },
                autochdir = false,
                open_last_workspace = false,
            },
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
            },
        },
        ["core.concealer"] = {},
        ["core.keybinds"] = { -- Configure keybinds
            config = {
                default_keybinds = true, -- Generate the default keybinds
                neorg_leader = "<Leader>o", -- This is the default if unspecified
            },
        },
        ["core.journal"] = {
            config = {
                workspace = "gtd",
            },
        },
    },
})
