local providers = require("atlas.providers")
local resolve = providers.resolve

providers.resolve = function(value, opts)
    if type(value) == "string" then
        value = value:gsub("^https?://o365exchange%.visualstudio%.com/", "https://dev.azure.com/O365Exchange/")
    end
    return resolve(value, opts)
end

require("atlas").setup({
    ui = {
        -- Set either to false to keep your existing statusline.
        statusline = {
            atlas = true, -- Dashboards, details, and other non-diff Atlas views.
            diff = true,  -- Diff and review views.
        },
        -- "auto", "default", "snacks", or "fzf-lua".
        picker = "auto",
        -- Make the main Atlas dashboard a listed buffer.
        listed_buffer = false,
    },
    providers = {
        azure = {
            base_url = "https://dev.azure.com/O365Exchange",
            -- https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate
            token = vim.env.AZURE_DEVOPS_TOKEN,
            cache_ttl = 300, -- Set to 0 to disable caching.
        },
    },
    pulls = {
        diff = {
            -- "auto", or a command that accepts explicit <base>...<head> Git revisions.
            open_cmd = "AtlasDiff",            -- CodeDiff, DiffviewOpen or AtlasDiff
            comment_display = "virtual_lines", -- "virtual_lines" or compact "virtual_text" hints.
            review_panel = {
                hidden = true,                 -- Set false to show the review panel when a diff opens.
                height = 10,
            },

            -- AtlasDiff options; external viewers use their own configuration.
            layout = "inline", -- "inline" or "side-by-side".
            compact = false,   -- Start with only changed hunks and surrounding context visible.
            lsp = {
                -- Back the new side of the diff with a detached worktree at the PR head so it is made of
                -- real files and your language servers attach to it (AtlasDiff and CodeDiff). Off by default.
                enabled = true,
                -- Defaults to `stdpath("cache")/atlas/worktrees/<repo>/pr-<id>` (or `<repo>/<sha>` without a PR).
                -- May be an absolute path, or a function receiving
                -- { repo_root, repo_full_name, pr_id, head_sha, default } that returns a path or nil.
                dir = nil,
                -- Directories symlinked from your checkout into the worktree so servers can resolve
                -- dependencies. These are the same directories on disk, not copies.
                link = { "target" }, -- e.g. { "node_modules", ".venv" }
            },
            explorer = {
                grouped = true,          -- Group changed files by directory.
                hidden = false,
                show_commits = false,    -- Set true to show commits below changed files initially.
                width = 40,
                initial_focus = "diff",  -- "explorer" or "diff".
                preview = true,          -- Show a file as soon as the explorer cursor moves onto it.
                focus_on_select = false, -- Move into the diff after selecting a file.
                ignore = { ".git/**", ".jj/**" },
            },
        },
        azure = {
            views = {
                {
                    name = "Reviewing",
                    key = "1",
                    layout = "grouped", -- "compact", "grouped", or "plain"
                    project = "O365 Core",
                    scope = "assigned_to_me",
                },
                {
                    name = "Created",
                    key = "2",
                    project = "O365 Core",
                    scope = "created_by_me", -- Or "all".
                    extra_params = {
                        ["searchCriteria.targetRefName"] = "refs/heads/master",
                    },
                },
            },
        },
        repo_config = {
            -- Maps `namespace/repo` to local paths. Used for checkout, diffs, and custom actions.
            paths = {
                ["O365 Core/TenantsFeedback/*"] = "~/Documents/TenantsFeedback.git",
            },
        },
    },
    issues = {},

})
