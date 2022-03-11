local opt = vim.opt
local call = vim.call
local vimscript = vim.api.nvim_exec
local highlight = vim.highlight.create
local set_highlight = vim.api.nvim_set_hl
local command = vim.cmd

-- Vim options
vimscript("filetype plugin indent on", false)
vimscript("au FileType * setlocal fo-=c fo-=r fo-=o", false)

opt.smartindent = true
opt.autoindent = true
opt.expandtab = true

-- Tabstop: Number of space in a <Tab>
opt.tabstop = 4

-- Shiftwidth: Number of spaces in an indentation
opt.shiftwidth = 4

-- Softtabstop: How many columns is a <Tab> or <BS>
opt.softtabstop = 4

opt.tw = 90

-- Buffers
opt.hidden = true
opt.splitright = true
opt.splitbelow = true

-- Random
opt.number = true
opt.wrap = false
opt.smartcase = true
opt.ignorecase = true
opt.mouse = "a"
opt.scrolloff = 5
opt.relativenumber = true
opt.timeoutlen = 300
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Completion
opt.completeopt = "menuone,noselect"
opt.pumheight = 10

-- Visuals
opt.termguicolors = true
opt.signcolumn = "yes:1"

-- Vimtex
vim.g.vimtex_fold_enabled = true

vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_colors = {
	info = "#FFFFFF",
	hint = "#FFFFFF",
}
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_italic_comments = false
vimscript("colorscheme tokyonight", false)

-- LightMode command
function _G.LightMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Day", false)
	vim.o.background = "light"
	vimscript("colorscheme tokyonight", false)
	-- require('github-theme').setup({
	--     theme_style = "light",
	--     dark_sidebar = false,
	--     hide_end_of_buffer = true
	-- })
end

function _G.DarkMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Storm", false)
	vim.o.background = "dark"
	vimscript("colorscheme tokyonight", false)
end

function _G.ToggleThemeMode()
	if vim.o.background == "dark" then
		_G.LightMode()
	else
		_G.DarkMode()
	end
end

vimscript("command! LightMode :lua LightMode()", false)
vimscript("command! DarkMode :lua DarkMode()", false)

-- Remove spelling mistake highlight

-- Persistent undo
local undoDir = "/tmp/.undodir_" .. vim.env["USER"]
if not vim.fn.isdirectory(undoDir) then
	vim.fn.mkdir(undoDir, "", 0700)
end
opt.undodir = undoDir
opt.undofile = true

-- Swap files
opt.swapfile = false




