-- Allow after/plugin to be required
local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path

require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- Mini provides pairs, surround, commenting and bufremoval functionality
    use("echasnovski/mini.nvim")

    -- "Buffers"
    use({
        "akinsho/bufferline.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })

    -- Visuals
    use("folke/tokyonight.nvim")

    -- "Files and git"
    use("tpope/vim-fugitive")
    use("lewis6991/gitsigns.nvim")
    use("sindrets/diffview.nvim")

    -- Telescope
    use("nvim-telescope/telescope.nvim")
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })
    use("AckslD/nvim-neoclip.lua")

    -- IDE
    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
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
    })

    -- "LSP, languages and tools"
    use("neovim/nvim-lspconfig")
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
    use("jose-elias-alvarez/null-ls.nvim")
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
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lsp")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-path")
    use("kdheepak/cmp-latex-symbols")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lsp-signature-help")

    -- "Treesitter & Syntax highlighting"
    use("nvim-treesitter/nvim-treesitter")
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")

    -- "Snippets"
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

    -- "Notes and organization"
    use("lervag/vimtex")
    use("vhyrro/neorg")
end)

-- Load rest of config

require("maps")
require("opts")
require("lsp")
require("language_configs")
require("theme")
require("leadermaps")

-- Master thesis work
require("ccdetect")
