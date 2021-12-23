local wk = require("which-key")

vim.g.mapleader = " "

local utils = require("utils")

local telescope_find_dir = _G.telescope_find_dir
local telescope_find_dir_home = _G.telescope_find_dir_home
local telescope_find_dir_hidden = _G.telescope_find_dir_hidden

local lsp = vim.lsp.buf
local diagnostic = vim.diagnostic

wk.register({
	f = {
		name = "find",
		f = { "<CMD>Telescope find_files<CR>", "find-files" },
		d = {
			function()
				_G.telescope_find_dir()
			end,
			"find-directory",
		},
		g = { "<CMD>Telescope git_files prompt_prefix=🔍<CR>", "find-git" },
		r = { '<CMD>Ranger --choosedir="/tmp/ranger_dir"<CR>', "find-ranger" },
		l = { "<CMD>NvimTreeToggle<CR>", "file-tree" },
		c = { "<CMD>Telescope live_grep prompt_prefix=🔍<CR>", "file-tree" },
		p = { "<CMD>Telescope neoclip<CR>", "find-clipboard" },
		t = { "<CMD>Telescope termfinder find<CR>", "find-termminal" },
		h = {
			name = "find-home",
			f = {
				"<CMD>Telescope find_files find_command=rg,--files,/home/ prompt_prefix=🔍<CR>",
				"find-home-files",
			},
			d = {
				function()
					_G.telescope_find_dir_home()
				end,
				"find-home-dir",
			},
		},
		b = { "<CMD>Telescope buffers<CR>", "find-buffers" },
		z = {
			name = "find-hidden-dir",
			f = {
				"<CMD>Telescope find_files find_command=rg,--files,--hidden prompt_prefix=🔍<CR>",
				"find-hidden-file",
			},
			d = {
				function()
					_G.telescope_find_dir_hidden()
				end,
				"find-hidden-dir",
			},
		},
	},

	b = {
		name = "buffer",
		d = { "<CMD>Bclose<CR>", "buffer-close" },
		e = { "<CMD>enew<CR>", "open-empty-buffer" },
		x = { "<CMD>close<CR>", "window-close" },
		v = { "<CMD>vsplit<CR>", "vertical-split" },
		h = { "<CMD>split<CR>", "horizontal-split" },
		o = { "<CMD>ZoomWinTabToggle<CR>", "maximize-buffer" },
		m = { "<CMD>WinShift<CR>", "buffer-move" },
	},
	l = {
		name = "lsp",
		d = { lsp.definition, "goto-definition" },
		h = { lsp.hover, "show-hover" },
		s = { lsp.signature_help, "show-signature" },
		r = { lsp.references, "goto-references" },
		n = { lsp.rename, "rename-symbol" },
		a = { lsp.code_action, "code-actions" },
		p = { "<CMD>Neoformat<CR>", "prettier-format" },
		e = {
			name = "diagnostics",
			e = { "<CMD>TroubleToggle<CR>", "diagnostic-overview" },
			l = { diagnostic.open_float, "line-diagnostics" },
		},
	},
	t = {
		name = "terminal",
		t = { "<CMD>exe v:count1 . 'ToggleTerm'<CR>", "popup-terminal" },
		f = { "<CMD>terminal<CR>", "full-terminal" },
	},
	g = {
		name = "git",
		s = { "<CMD>Ge :<CR>", "git-status" },
		c = { "<CMD>Telescope git_commits prompt_prefix=🔍<CR>", "git-status" },
		b = { "<CMD>silent Merginal<CR>", "git-branches" },
		h = { "<CMD>Git blame<CR>", "git-blame" },
		m = { "<CMD>Git mergetool<CR>", "git-mergetool" },
		v = { "<CMD>silent !gh repo view --web<CR>", "git-browser" },
	},
	p = {
		name = "path",
		h = { "<CMD>cd $HOME<CR>", "path-home" },
		g = { utils.CWDgitRoot, "path-git-root" },
		n = { "<CMD>cd $HOME/.config/nvim<CR>", "path-neovim-config" },
		c = { "<CMD>cd %:p:h<CR>", "path-current-file" },
		o = { "<CMD>cd $HOME/.config/gtd<CR>", "path-gtd" },
	},
    o = {
        name = "organize",
        h = { "<CMD>Neorg journal custom " .. utils.getFirstDayOfCurrentMonth() .. "<CR>", "journal"}
    },
	-- Uncategorized
	s = {
		name = "which_key_ignore",
		s = { "<CMD>Startify<CR>", "which_key_ignore" },
	},
	w = { "<CMD>w<CR>", "which_key_ignore" },
	n = {
		name = "which_key_ignore",
		o = { "<CMD>nohlsearch<CR>", "which_key_ignore" },
	},
	["<BS>"] = { "<CMD>cd ..<CR>", "which_key_ignore" },
}, { prefix = "<Leader>" })

wk.register({
	l = {
		name = "lsp",
		a = { lsp.range_code_action, "code-actions" },
	},
}, { prefix = "<Leader>", mode = "v" })
