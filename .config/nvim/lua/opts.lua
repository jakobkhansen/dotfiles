local opt = vim.opt
local vimscript = vim.api.nvim_exec

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
opt.wrap = false
opt.smartcase = true
opt.ignorecase = true
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
opt.statusline = "%f %h%w%m%r %=%(%{getcwd()} %l,%c%V %= %P %)"

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
