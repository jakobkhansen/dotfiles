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

    -- Telescope,
    "nvim-telescope/telescope.nvim",
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "make",
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
    "mrcjkb/rustaceanvim",
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {}
    },
    "windwp/nvim-ts-autotag",
    "zbirenbaum/copilot.lua",

    -- nvim-cmp auto-completion,
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",

    -- "Treesitter & Syntax highlighting",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",

    -- "Snippets",
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp"
    },
    "rafamadriz/friendly-snippets",

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
-- require("ccdetect")
