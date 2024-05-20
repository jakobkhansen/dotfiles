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
    -- Mini provides pairs, surround, commenting and bufremoval functionality,
    "echasnovski/mini.nvim",

    -- "Buffers",
    {
        "akinsho/bufferline.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
    },

    -- Visuals,
    "folke/tokyonight.nvim",

    -- "Files and git",
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",

    -- Telescope,
    "nvim-telescope/telescope.nvim",
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
        "AckslD/nvim-neoclip.lua",
        config = function()
            require("neoclip").setup()
        end,
    },

    -- IDE, UI
    {
        "goolord/alpha-nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },

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

    -- "LSP, languages and tools",
    "neovim/nvim-lspconfig",
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    "nvimtools/none-ls.nvim",
    "onsails/lspkind-nvim",
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            { 'Issafalcon/neotest-dotnet', commit = "1532f6123207dcfe36263e7f3182609f68588da8" },
            'jakobkhansen/neotest-jest',
            "nvim-neotest/nvim-nio",
        }
    },
    "mfussenegger/nvim-dap",
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "simrat39/rust-tools.nvim",
        config = function()
            require("rust-tools").setup()
        end,
    },
    "jmederosalvarado/roslyn.nvim",
    "windwp/nvim-ts-autotag",
    {
        "zbirenbaum/copilot.lua",
    },

    -- nvim-cmp auto-completion,
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-path",
    "kdheepak/cmp-latex-symbols",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-calc",

    -- "Treesitter & Syntax highlighting",
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            if vim.uv.os_uname().sysname == "Darwin" then
                require("nvim-treesitter.install").compilers = { "gcc-13" }
            end
        end
    },
    "nvim-treesitter/nvim-treesitter-textobjects",

    -- "Snippets",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",

    -- "Notes and organization",
    {
        dir = '/Users/jakobhansen/Documents/OpenSource/journal.nvim',
    }
    -- "jakobkhansen/journal.nvim"
})

-- Load rest of config

require("theme")
require("maps")
require("opts")
require("lsp")
require("language_configs")
require("leadermaps")

-- Master thesis work
-- require("ccdetect")
