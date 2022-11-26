require("neorg").setup({
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    gtd = "~/Documents/gtd",
                },
                autochdir = false,
                open_last_workspace = false,
            },
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
            },
        },
        ["core.norg.concealer"] = {},
        ["core.keybinds"] = { -- Configure core.keybinds
            config = {
                default_keybinds = true, -- Generate the default keybinds
                neorg_leader = "<Leader>o", -- This is the default if unspecified
            },
        },
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode",
            },
        },
        ["core.gtd.ui"] = {},
        ["core.gtd.queries"] = {},
        ["core.gtd.base"] = {
            config = {
                workspace = "gtd",
                exclude = {
                    "journal",
                },
            },
        },
        ["core.norg.journal"] = {
            config = {
                workspace = "gtd",
            },
        },
    },
})
