require("neogit").setup({
    kind = "replace",
    mappings = {
        popup = {
            ["l"] = false,
            ["v"] = false,
            ["Z"] = false,
            ["w"] = false,
            ["b"] = false,
            ["B"] = "BranchPopup"
        },
        status = {
            ["<tab>"] = false,
            ["ZZ"] = "Close",
            ["="] = "Toggle",
        }

    },
    git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
        ["gitlab.com"] =
        "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        ["azure.com"] =
        "https://dev.azure.com/${owner}/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
    },
})
