local wk = require("which-key")

vim.g.mapleader = " "

local utils = require("utils")

local lsp = vim.lsp.buf
local diagnostic = vim.diagnostic

wk.register({

	-- Find x

	f = {
		name = "find",
		f = { "<CMD>Telescope find_files<CR>", "find-files" },
		d = { "<CMD>Telescope file_browser files=false hide_parent_dir=true cwd_to_path=true<CR>", "find-directory" },
		g = { "<CMD>Telescope git_files prompt_prefix=🔍<CR>", "find-git" },
		r = { '<CMD>Ranger --choosedir="/tmp/ranger_dir"<CR>', "find-ranger" },
		b = { "<CMD>Telescope file_browser cwd_to_path=true hide_parent_dir=true<CR>", "file-browser" },
		c = { "<CMD>Telescope live_grep prompt_prefix=🔍<CR>", "file-tree" },
		p = { "<CMD>Telescope neoclip<CR>", "find-clipboard" },
		t = { "<CMD>Telescope termfinder find<CR>", "find-termminal" },
		w = { "<CMD>Telescope buffers<CR>", "find-buffers" },
		j = { "<CMD>Telescope jumplist<CR>", "find-jump" },
	},

	-- Buffer
	b = {
		name = "buffer",
		d = { "<CMD>lua MiniBufremove.wipeout(0, true)<CR>", "buffer-close" },
		e = { "<CMD>enew<CR>", "open-empty-buffer" },
		x = { "<CMD>close<CR>", "window-close" },
		v = { "<CMD>vsplit<CR>", "vertical-split" },
		h = { "<CMD>split<CR>", "horizontal-split" },
		o = { "<CMD>ZoomWinTabToggle<CR>", "maximize-buffer" },
		m = { "<CMD>WinShift<CR>", "buffer-move" },
	},

	-- LSP
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

	-- Terminal
	t = {
		name = "terminal",
		t = { "<CMD>exe v:count1 . 'ToggleTerm'<CR>", "popup-terminal" },
		f = { "<CMD>terminal<CR>", "full-terminal" },
	},

	-- Git
	g = {
		name = "git",
		s = { "<CMD>Ge :<CR>", "git-status" },
		c = { "<CMD>Telescope git_commits prompt_prefix=🔍<CR>", "git-status" },
		b = { "<CMD>silent Merginal<CR>", "git-branches" },
		h = { "<CMD>Git blame<CR>", "git-blame" },
		m = { "<CMD>Git mergetool<CR>", "git-mergetool" },
		v = { "<CMD>silent !gh repo view --web<CR>", "git-browser" },
	},

	-- Path, cwd
	p = {
		name = "path",
		h = { "<CMD>cd $HOME<CR>", "path-home" },
		g = { utils.CWDgitRoot, "path-git-root" },
		n = { "<CMD>cd $HOME/.config/nvim<CR>", "path-neovim-config" },
		c = { "<CMD>cd %:p:h<CR>", "path-current-file" },
		o = { "<CMD>cd $HOME/Documents/gtd<CR>", "path-gtd" },
		k = { "<CMD>cd $HOME/Documents/Personal/KattisSolutions<CR>", "path-kattis" },
		s = { "<CMD>cd $HOME/Documents/School<CR>", "path-school" },
	},

	-- Neorg
	o = {
		name = "organize",
		h = { "<CMD>Neorg journal custom " .. utils.getFirstDayOfCurrentMonth() .. "<CR>", "hours" },
		j = { "<CMD>Neorg journal today<CR>", "journal" },
		p = { "<CMD>edit $HOME/Documents/gtd/projects.norg<CR>", "projects" },
		t = {
			name = "task",
			t = { "<CMD>Neorg gtd views<CR>", "task-overview" },
			c = { "<CMD>Neorg gtd capture<CR>", "task-capture" },
			e = { "<CMD>Neorg gtd edit<CR>", "task-edit" },
		},
	},

    -- Shortcuts
    s = {
        name = "shortcuts",
        p = {"<CMD>PackerSync<CR>", "packer-sync"},
        s = {"<CMD>Startify<CR>", "startify"},
        t = {"<CMD>lua ToggleThemeMode()<CR>", "toggle-theme"}
    },

	-- Help
	h = {
		name = "help",
		t = { "<CMD>Telescope help_tags<CR>", "help-tags" },
		w = { '<CMD>execute "h " . expand("<cword>")<CR>', "help-tags" },
	},

	-- Uncategorized
	w = { "<CMD>w<CR>", "which_key_ignore" },
	n = {
		name = "which_key_ignore",
		o = { "<CMD>nohlsearch<CR>", "which_key_ignore" },
	},
	["<BS>"] = { "<CMD>cd ..<CR>", "which_key_ignore" },
	["<CR>"] = { "<CMD>TermExec go_back=1 cmd='!!'<CR>", "which_key_ignore" },
}, { prefix = "<Leader>" })

wk.register({
	l = {
		name = "lsp",
		a = { lsp.range_code_action, "code-actions" },
	},
}, { prefix = "<Leader>", mode = "v" })
