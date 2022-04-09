local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
	pattern = { "javascript,javascriptreact,typescript,typescriptreact", "norg", "cpp,cmake" },
	command = "setlocal sts=2 ts=2 sw=2",
})

autocmd("FileType", {
	pattern = {"*.cup"},
	command = "set filetype=cup",
})

autocmd("FileType", {
	pattern = {"*.cmp"},
	command = "set filetype=cmp",
})
