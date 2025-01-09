require("neotest").setup({
    adapters = {
        require("neotest-jest")({
            jestCommand = "yarn test",
            cwd = function(path)
                return vim.fn.getcwd()
            end,
        }),
        require("neotest-dotnet")({
            discovery_root = "project",
        })
    },
})
