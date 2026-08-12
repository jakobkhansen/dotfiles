require("codecompanion").setup({
    interactions = {
        chat = {
            adapter = "copilot_acp",
            editor_context = {
                ["buffer"] = {
                    opts = {
                        default_params = "all",
                    },
                },
            },
        },
        inline = {
            adapter = "copilot_acp",
        },
        cli = {
            agent = "copilot_cli",
            agents = {
                copilot_cli = {
                    cmd = "copilot",
                    args = {},
                    description = "Copilot CLI",
                    provider = "terminal",
                },
            },
        },
    },
})
