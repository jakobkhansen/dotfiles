local wk = require("which-key")

vim.g.mapleader = " "

local utils = require("utils")

local lsp = vim.lsp.buf
local dap = require("dap")
local diagnostic = vim.diagnostic

wk.register({
	f = {
		name = "find",
		f = { "<CMD>Telescope find_files<CR>", "find-files" },
		d = { "<CMD>Telescope file_browser files=false hide_parent_dir=true cwd_to_path=true<CR>", "find-directory" },
		g = { "<CMD>Telescope git_files prompt_prefix=🔍<CR>", "find-git" },
		n = { "<CMD>Explore<CR>", "find-netrw" },
		r = { '<CMD>Ranger --choosedir="/tmp/ranger_dir"<CR>', "find-ranger" },
		l = { "<CMD>Telescope file_browser cwd_to_path=true hide_parent_dir=true<CR>", "file-browser" },
		o = { "<CMD>Telescope oldfiles<CR>", "find-mru" },

		c = { "<CMD>Telescope live_grep prompt_prefix=🔍<CR>", "find-code" },
		h = { "<CMD>Telescope heading<CR>", "find-heading" },

		p = { "<CMD>Telescope neoclip<CR>", "find-clipboard" },
		t = { "<CMD>Telescope termfinder find<CR>", "find-termminal" },
		b = { "<CMD>Telescope buffers<CR>", "find-buffers" },
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
		m = { "<CMD>WinShift<CR>", "buffer-move" },
		t = { "<CMD>tabnew<CR>", "tab-new" },
	},

	-- LSP
	l = {
		name = "lsp",
		d = { lsp.definition, "goto-definition" },
		h = { lsp.hover, "show-hover" },
		s = { lsp.signature_help, "show-signature" },
		r = { lsp.references, "goto-references" },
		x = { "<CMD>LspRestart<CR>", "goto-references" },
		i = { "<CMD>LspInfo<CR>", "lsp-info" },
		l = { "<CMD>e /home/jakob/.cache/nvim/lsp.log<CR>", "lsp-log" },
		n = { lsp.rename, "rename-symbol" },
		a = { lsp.code_action, "code-actions" },
		p = { "<CMD>Neoformat<CR>", "prettier-format" },
		e = {
			name = "diagnostics",
			e = { "<CMD>Telescope diagnostics<CR>", "diagnostic-overview" },
			l = { diagnostic.open_float, "line-diagnostics" },
            n = { diagnostic.goto_next, "goto-next" },
            p = { diagnostic.goto_prev, "goto-prev" },
		},
	},

    -- DAP
    d = {
        name = "debug",
        r = {dap.continue, "run"},
        b = {dap.toggle_breakpoint, "toggle-breakpoint"}
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
		b = { "<CMD>Telescope git_branches<CR>", "git-branches" },
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
		h = { "<CMD>silent! NeorgStart<CR><CMD>Neorg journal custom " .. utils.getFirstDayOfCurrentMonth() .. "<CR>", "hours" },
		j = { "<CMD>silent! NeorgStart<CR><CMD>Neorg journal today<CR>", "journal" },
		p = { "<CMD>edit $HOME/Documents/gtd/projects.norg<CR>", "projects" },
        t = {
            name = "timetrap",
            i = {require("plugins.timetrap-config").check_in, "check-in"},
            o = {"<CMD>Timetrap out<CR>", "check-out"},
            r = {"<CMD>Timetrap resume<CR>", "resume"},
            d = {"<CMD>Timetrap d<CR>", "display"},
            n = {"<CMD>Timetrap now<CR>", "now"}
        }
	},

    -- Shortcuts
    s = {
        name = "shortcuts",
        p = {"<CMD>PackerSync<CR>", "packer-sync"},
        s = {"<CMD>Alpha<CR>", "Start-screen"},
        t = {utils.ToggleThemeMode, "toggle-theme"},
        z = {"<CMD>ZenMode<CR>", "toggle-zen"},
        c = {"<CMD>ScrollbarToggle<CR>", "toggle-scrollbar"}
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
		a = { "<Esc>gv<CMD>lua vim.lsp.buf.range_code_action()<CR>", "code-actions" },
	},
}, { prefix = "<Leader>", mode = "v" })
