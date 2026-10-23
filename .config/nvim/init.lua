-- Allow after/plugin to be required
local conf_dir = vim.fn.stdpath("config")
package.path = conf_dir .. "/after/plugin/?.lua;" .. package.path

-- Bootstrap plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    -- Mini provides pairs, surround, commenting and bufremoval functionality
    "echasnovski/mini.nvim",
    {
        "folke/snacks.nvim",
        lazy = false,
    },

    -- AI
    {
        "olimorris/codecompanion.nvim",
        version = "^19.0.0",
        cmd = {
            "CodeCompanion",
            "CodeCompanionChat",
            "CodeCompanionActions",
            "CodeCompanionCmd",
            "CodeCompanionCLI",
            "CodeCompanionCodeReview",
        },
        config = function()
            require("lazyload.codecompanion")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Buffers
    {
        "akinsho/bufferline.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "nvim-focus/focus.nvim",
    },

    -- Visuals,
    "folke/tokyonight.nvim",

    -- "Files and git"
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        config = function()
            require("lazyload.neogit")
        end,
    },
    "lewis6991/gitsigns.nvim",
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
            "DiffviewLog",
        },
    },

    {
        "emrearmagan/atlas.nvim",
        branch = "feat/azure",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- optional but recommended
            "esmuellert/codediff.nvim",    -- optional (PullRequest diff)
            "sindrets/diffview.nvim",      -- optional; or "dlyongemallo/diffview-plus.nvim"
        },
        opts = {
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
                    open_cmd = "auto",                 -- CodeDiff, DiffviewOpen or AtlasDiff
                    comment_display = "virtual_lines", -- "virtual_lines" or compact "virtual_text" hints.
                    review_panel = {
                        hidden = true,                 -- Set false to show the review panel when a diff opens.
                        height = 10,
                    },

                    -- AtlasDiff options; external viewers use their own configuration.
                    layout = "inline", -- "inline" or "side-by-side".
                    compact = true,    -- Start with only changed hunks and surrounding context visible.
                    lsp = {
                        -- Back the new side of the diff with a detached worktree at the PR head so it is made of
                        -- real files and your language servers attach to it (AtlasDiff and CodeDiff). Off by default.
                        enabled = false,
                        -- Defaults to `stdpath("cache")/atlas/worktrees/<repo>/pr-<id>` (or `<repo>/<sha>` without a PR).
                        -- May be an absolute path, or a function receiving
                        -- { repo_root, repo_full_name, pr_id, head_sha, default } that returns a path or nil.
                        dir = nil,
                        -- Directories symlinked from your checkout into the worktree so servers can resolve
                        -- dependencies. These are the same directories on disk, not copies.
                        link = {}, -- e.g. { "node_modules", ".venv" }
                    },
                    explorer = {
                        grouped = true,             -- Group changed files by directory.
                        hidden = false,
                        show_commits = false,       -- Set true to show commits below changed files initially.
                        width = 40,
                        initial_focus = "explorer", -- "explorer" or "diff".
                        preview = false,            -- Show a file as soon as the explorer cursor moves onto it.
                        focus_on_select = false,    -- Move into the diff after selecting a file.
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
        },


    },

    -- IDE, UI
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker",
                config = function()
                    require("window-picker").setup()
                end,
            },
        },
    },

    -- "LSP, languages and tools"
    "neovim/nvim-lspconfig",
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvimtools/none-ls-extras.nvim" },
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    },
    {
        "nvim-neotest/neotest",
        cmd = "Neotest",
        config = function()
            require("lazyload.neotest")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            'Issafalcon/neotest-dotnet',
            'jakobkhansen/neotest-jest',
            "nvim-neotest/nvim-nio",
        }
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function()
            require("lazyload.dap")
        end,
    },
    "yioneko/nvim-vtsls",
    "mrcjkb/rustaceanvim",
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {
            filewatching = "roslyn",
        }
    },
    "windwp/nvim-ts-autotag",

    -- nvim-cmp auto-completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("lazyload.cmp")
        end,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind-nvim",
            "L3MON4D3/LuaSnip",
        },
    },

    -- "Treesitter & Syntax highlighting",
    { "nvim-treesitter/nvim-treesitter",             branch = "main" },
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

    -- "Snippets"
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        -- build = "make install_jsregexp"
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("lazyload.luasnip")
        end,
    },

    -- "Notes and organization",
    "jakobkhansen/journal.nvim",
})

-- Load rest of config
require("theme")
require("maps")
require("opts")
require("lsp")
require("language_configs")
require("leadermaps")
require("gitdiff")
