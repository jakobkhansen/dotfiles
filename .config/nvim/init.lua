-- Plugins
require("packer").startup(function(use)
	-- "Libraries and dependencies"
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("nathom/filetype.nvim")

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
	use("kyazdani42/nvim-web-devicons")
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("plugins.zenmode-config")
		end,
	})

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

	-- "IDE"
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugins.telescope-config")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
			require("telescope").load_extension("neoclip")
		end,
	})

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("plugins.alpha-nvim-config")
		end,
	})

	use({
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
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

	-- "LSP and languages"
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.lsp-config")
			require("plugins.lsp-servers")
		end,
	})
	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.dap-config")
		end,
	})
	use("mfussenegger/nvim-jdtls")
	use("onsails/lspkind-nvim")

	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("windwp/nvim-ts-autotag")

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
	use("uga-rosa/cmp-dictionary")
	use("hrsh7th/cmp-calc")
	use("ray-x/cmp-treesitter")

	use({
		"sbdchd/neoformat",
		config = function()
			require("plugins.neoformat-config")
		end,
	})

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
		"ekickx/clipboard-image.nvim",
		config = function()
			require("plugins.clipboard-image-config")
		end,
	})
	use("crispgm/telescope-heading.nvim")

	use({
		"andreadev-it/timetrap.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("plugins.timetrap-config")
		end,
	})
end)

-- Load rest of config

require("maps")
require("opts")
require("leadermaps")
require("language_configs")

-- Master thesis work
require("ccdetect")
