local Plug = vim.fn['plug#']



vim.call('plug#begin', '$HOME/.config/nvim/plugged')

    --"Plugin dependencies"
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'RishabhRD/popfix'
	Plug 'rbgrouleff/bclose.vim'

	--"Text manipulation"
	Plug 'scrooloose/nerdcommenter'
	Plug 'windwp/nvim-autopairs'
    Plug 'tpope/vim-surround'

	--"Movement"
	Plug 'psliwka/vim-smoothie'

	--"Syntax highlighting"
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn['TSUpdate']})
    Plug 'nvim-treesitter/playground'
	Plug 'sheerun/vim-polyglot'

	--"Buffers"
	Plug 'troydm/zoomwintab.vim'
    Plug 'kwkarlwang/bufresize.nvim'


	--"Themes and Visuals"
	Plug 'christianchiarulli/nvcode-color-schemes.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'lukas-reineke/indent-blankline.nvim'

	Plug 'kyazdani42/nvim-web-devicons'
    Plug 'jakobkhansen/tokyonight.nvim'
    Plug 'ishan9299/nvim-solarized-lua'
    Plug 'projekt0n/github-nvim-theme'


	--"Files and git"
    Plug 'Pocco81/AutoSave.nvim'
	Plug 'kyazdani42/nvim-tree.lua'
	Plug 'tpope/vim-fugitive'
	Plug 'idanarye/vim-merginal'
	Plug 'rhysd/conflict-marker.vim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'is0n/fm-nvim'

    -- "Terminal"
    Plug 'akinsho/toggleterm.nvim'

	--"Menus"
	Plug 'nvim-telescope/telescope.nvim'
    Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make'})
	Plug 'mhinz/vim-startify'
	Plug 'spinks/vim-leader-guide'
    Plug 'folke/trouble.nvim'

	--"LSP"
	Plug 'neovim/nvim-lspconfig'

    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'hrsh7th/cmp-path'
    Plug 'kdheepak/cmp-latex-symbols'

	Plug 'mfussenegger/nvim-jdtls'
	--Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
    --Plug 'jose-elias-alvarez/null-ls.nvim'
    Plug 'sbdchd/neoformat'

	--"Snippets"
	Plug 'L3MON4D3/LuaSnip'
    Plug 'rafamadriz/friendly-snippets'

	--"Notes and organization"
	Plug 'reedes/vim-pencil'
	Plug 'instant-markdown/vim-instant-markdown'
	Plug 'lervag/vimtex'
    Plug('vhyrro/neorg', {['branch'] = 'unstable'})
    Plug 'preservim/vim-pencil'


	--"Random"
	Plug 'andweeb/presence.nvim'
    Plug 'svermeulen/vimpeccable'

vim.call('plug#end')
-- Require modules

require('maps')
require('opts')
require('leadermaps')
require('language_configs')

-- Require plugins
require('plugins.treesitter-config')
require('plugins.lsp-config')
require('plugins.lsp-servers')
require('plugins.trouble-config')

require('plugins.toggleterm')
require('plugins.bufresize-config')

require('plugins.luasnips')

require('plugins.neorg-config')

require('plugins.nvim-tree-config')
require('plugins.telescope-config')
require('plugins.autosave-config')

require('plugins.airline-config')
require('plugins.startify-config')

require('plugins.nerdcommenter-config')
require('plugins.gitsigns-config')
require('plugins.icons')
require('plugins.markdown-config')
require('plugins.nvim-cmp-config')
require('plugins.latex-config')
require('plugins.neoformat-config')

require('plugins.nvim-autopairs-config')
