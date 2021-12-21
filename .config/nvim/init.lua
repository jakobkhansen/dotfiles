require("packer").startup(function(use)
	-- "Libraries and dependencies"
	use("wbthomason/packer.nvim")
	use("svermeulen/vimpeccable")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("RishabhRD/popfix")
	use("rbgrouleff/bclose.vim")

	-- "Text manipulation"
	use({
		"scrooloose/nerdcommenter",
		config = function()
			require("plugins.nerdcommenter-config")
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("plugins.nvim-autopairs-config")
		end,
	})
	use("tpope/vim-surround")
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("jose-elias-alvarez/null-ls.nvim")

	--"Movement"
	use("psliwka/vim-smoothie")

	-- "Syntax highlighting"
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugins.treesitter-config")
		end,
	})
	use("nvim-treesitter/playground")
	use("windwp/nvim-ts-autotag")
	use("sheerun/vim-polyglot")

	-- "Buffers"
	use("troydm/zoomwintab.vim")
	use({
		"kwkarlwang/bufresize.nvim",
		config = function()
			require("bufresize").setup()
		end,
	})
	use("sindrets/winshift.nvim")

	-- "Themes and Visuals"
	use("christianchiarulli/nvcode-color-schemes.vim")

    use({
        "akinsho/bufferline.nvim",
        config = function()
            require("plugins.bufferline-config")
        end,
        requires = "kyazdani42/nvim-web-devicons",
    })
	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.icons")
		end,
	})
    use("jakobkhansen/tokyonight.nvim")
	use("projekt0n/github-nvim-theme")

	-- "Files and git"
	use({
		"Pocco81/AutoSave.nvim",
		config = function()
			require("plugins.autosave-config")
		end,
	})

	use("tpope/vim-fugitive")
	use({ "idanarye/vim-merginal", branch = "develop" })
	use("rhysd/conflict-marker.vim")
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugins.gitsigns-config")
		end,
	})

	-- "Terminal"
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("plugins.toggleterm-config")
		end,
	})
	use({ "tknightz/telescope-termfinder.nvim" })

	-- "Menus"
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugins.telescope-config")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("plugins.nvim-tree-config")
		end,
	})
	use({
		"mhinz/vim-startify",
		config = function()
			require("plugins.startify-config")
		end,
	})
	use("spinks/vim-leader-guide")
	use({
		"folke/trouble.nvim",
		config = function()
			require("plugins.trouble-config")
		end,
	})
	use({
		"is0n/fm-nvim",
		config = function()
			require("plugins.fm-nvim-config")
		end,
	})
	use({
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
			require("telescope").load_extension("neoclip")
		end,
	})

	-- "LSP"
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.lsp-config")
			require("plugins.lsp-servers")
		end,
	})
	use("mfussenegger/nvim-jdtls")
	use({
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({})
		end,
	})

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

	use({
		"onsails/lspkind-nvim",
	})

	use({
		"sbdchd/neoformat",
		config = function()
			require("plugins.neoformat-config")
		end,
	})

	-- "Snippets"
	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("plugins.luasnips-config")
		end,
	})
	use("rafamadriz/friendly-snippets")

	-- "Notes and organization"
	use("reedes/vim-pencil")
	use({
		"instant-markdown/vim-instant-markdown",
		config = function()
			require("plugins.markdown-config")
		end,
	})
	use({
		"lervag/vimtex",
		config = function()
			require("plugins.latex-config")
		end,
	})
	use({
		"vhyrro/neorg",
		branch = "better-concealing-performance",
		config = function()
			require("plugins.neorg-config")
		end,
		requires = "nvim-neorg/neorg-telescope",
	})
	use("nvim-neorg/neorg-telescope")
	use("andweeb/presence.nvim")
end)

-- Require plugins

require("maps")
require("opts")
require("leadermaps")
require("language_configs")
