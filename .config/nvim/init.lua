require("packer").startup(function(use)
    -- "Libraries and dependencies"
    use("wbthomason/packer.nvim")

    -- "Multi-functionality"
    -- Mini provides pairs, surround, commenting and bufremoval functionality
    use({
        "echasnovski/mini.nvim",
        config = function()
            require("plugins.mini-config")
        end,
    })

    -- Visuals
    use("folke/tokyonight.nvim")
    use({
        "utilyre/barbecue.nvim",
        requires = {
            "neovim/nvim-lspconfig",
            "smiteshp/nvim-navic",
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("barbecue").setup()
        end,
    })
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    })
    use("kyazdani42/nvim-web-devicons")

    -- "Files and git"
    use("tpope/vim-fugitive")
    use({
        "pwntester/octo.nvim",
        config = function()
            require("plugins.octo-config")
        end,
    })
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("plugins.gitsigns-config")
        end,
    })
    use({
        "sindrets/diffview.nvim",
        config = function()
            require("plugins.diffview-config")
        end,
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require("plugins.telescope-config")
        end,
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })
    use({
        "AckslD/nvim-neoclip.lua",
        config = function()
            require("neoclip").setup()
        end,
    })
    use({
        "ibhagwan/fzf-lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("plugins.fzf-config")
        end,
    })

    -- IDE
    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("plugins.alpha-nvim-config")
        end,
    })

    use({
        "folke/which-key.nvim",
        config = function()
            require("plugins.which-key-config")
        end,
    })

    use({
        "nvim-neo-tree/neo-tree.nvim",
        requires = {
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
        config = function()
            require("plugins.neotree-config")
        end,
    })

    -- "LSP, languages and tools"
    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.lsp-config")
            require("plugins.lsp-servers")
        end,
    })
    use({
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })
    use({
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("plugins.null-ls-config")
        end,
    })

    use("onsails/lspkind-nvim")
    use("mfussenegger/nvim-jdtls")
    use({
        "jose-elias-alvarez/typescript.nvim",
        config = function()
            require("typescript").setup({})
        end,
    })
    use({
        "simrat39/rust-tools.nvim",
        config = function()
            require("rust-tools").setup()
        end,
    })
    use("windwp/nvim-ts-autotag")

    -- nvim-cmp auto-completion
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.nvim-cmp-config")
        end,
    })
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lsp")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-path")
    use("kdheepak/cmp-latex-symbols")
    use("hrsh7th/cmp-cmdline")

    -- "Treesitter & Syntax highlighting"
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("plugins.treesitter-config")
        end,
    })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")

    -- "Snippets"
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            require("plugins.luasnips-config")
        end,
    })
    use("rafamadriz/friendly-snippets")

    -- "Notes and organization"
    use({
        "lervag/vimtex",
        config = function()
            require("plugins.vimtex-config")
        end,
    })
    use({
        "vhyrro/neorg",
        config = function()
            require("plugins.neorg-config")
        end,
    })
end)

-- Load rest of config

require("maps")
require("opts")
require("leadermaps")
require("language_configs")
require("theme")

-- Master thesis work
require("ccdetect")
