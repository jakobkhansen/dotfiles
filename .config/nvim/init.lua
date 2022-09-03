require("packer").startup(function(use)
    -- "Libraries and dependencies"
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use("nathom/filetype.nvim")
    use({
        "s1n7ax/nvim-window-picker",
        config = function()
            require("window-picker").setup()
        end,
    })
    use({
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })

    -- "Multi-functionality"
    -- Mini provides pairs, surround, commenting and bufremoval functionality
    use({
        "echasnovski/mini.nvim",
        config = function()
            require("plugins.mini-config")
        end,
    })

    --"Movement"
    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("plugins.neoscroll-config")
        end,
    })
    use({
        "petertriho/nvim-scrollbar",
        config = function()
            require("plugins.nvim-scrollbar-config")
        end,
    })

    -- "Buffers"
    use({
        "kwkarlwang/bufresize.nvim",
        config = function()
            require("bufresize").setup()
        end,
    })

    use({
        "akinsho/bufferline.nvim",
        config = function()
            require("plugins.bufferline-config")
        end,
        requires = "kyazdani42/nvim-web-devicons",
    })

    -- Visuals
    use("jakobkhansen/tokyonight.nvim")
    use({
        "nvim-lualine/lualine.nvim",
        config = function()
            require("plugins.lualine-config")
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

    -- "Terminal"
    use({
        "akinsho/toggleterm.nvim",
        config = function()
            require("plugins.toggleterm-config")
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
        "is0n/fm-nvim",
        config = function()
            require("plugins.fm-nvim-config")
        end,
    })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("plugins.neotree-config")
        end,
    })

    -- "LSP and languages"
    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.lsp-config")
            require("plugins.lsp-servers")
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
    use("jose-elias-alvarez/typescript.nvim")
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
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("kdheepak/cmp-latex-symbols")
    use("hrsh7th/cmp-cmdline")
    use("ray-x/cmp-treesitter")

    -- "Treesitter & Syntax highlighting"
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("plugins.treesitter-config")
        end,
    })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("RRethy/nvim-treesitter-textsubjects")

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
            require("plugins.latex-config")
        end,
    })
    use({
        "vhyrro/neorg",
        config = function()
            require("plugins.neorg-config")
        end,
    })
    use({
        "phaazon/mind.nvim",
        config = function()
            require("plugins.mind-config")
        end,
    })
    use({
        "ekickx/clipboard-image.nvim",
        config = function()
            require("plugins.clipboard-image-config")
        end,
    })

    use({
        "andreadev-it/timetrap.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("plugins.timetrap-config")
        end,
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- Load rest of config

require("maps")
require("opts")
require("leadermaps")
require("language_configs")

-- Master thesis work
require("ccdetect")
