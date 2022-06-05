local opt = vim.opt
local vimscript = vim.api.nvim_exec
local autocmd = vim.api.nvim_create_autocmd

-- Vim options
opt.smartindent = true
opt.expandtab = true

-- Tabstop: Number of space in a <Tab>
opt.tabstop = 4

-- Shiftwidth: Number of spaces in an indentation
opt.shiftwidth = 4

-- Softtabstop: How many columns is a <Tab> or <BS>
opt.softtabstop = 4

opt.tw = 90

-- Buffers
opt.splitright = true
opt.splitbelow = true

-- Random
opt.number = true
opt.mouse = "a"
opt.wrap = false
opt.smartcase = true
opt.ignorecase = true
opt.scrolloff = 5
opt.relativenumber = true
opt.timeoutlen = 300
opt.foldmethod = "indent"
opt.foldlevel = 99

vimscript("au FileType * setlocal fo-=c fo-=r fo-=o", false)
autocmd("FileType", {
	pattern = "*",
	command = "setlocal fo-=c fo-=r fo-=o",
})

-- Completion
opt.completeopt = "menuone,noselect"
opt.pumheight = 10

-- Visuals
opt.termguicolors = true
opt.signcolumn = "yes:1"
opt.laststatus = 3
opt.statusline = "%f %h%w%m%r %=%(%{getcwd()} %)"

vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_colors = {
	info = "#FFFFFF",
	hint = "#FFFFFF",
}
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_italic_comments = false
vimscript("colorscheme tokyonight", false)

-- Persistent undo
local undoDir = "/tmp/.undodir_" .. vim.env["USER"]
if not vim.fn.isdirectory(undoDir) then
	vim.fn.mkdir(undoDir, "", 0700)
end
opt.undodir = undoDir
opt.undofile = true

-- Swap files
opt.swapfile = false

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = "^\\..*"
vim.g.netrw_hide = 1
