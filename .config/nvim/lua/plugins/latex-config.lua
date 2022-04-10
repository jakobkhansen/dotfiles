local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufReadPost" }, { command = ":VimtexCompile", pattern = "*.tex" })


vim.g.vimtex_fold_enabled = true

vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_compiler_latexmk = {
	executable = "latexmk",
	options = {
		--'-pdflatex=lualatex',
		--'-lualatex',
		"-file-line-error",
		"-synctex=1",
		"-interaction=nonstopmode",
	},
}
