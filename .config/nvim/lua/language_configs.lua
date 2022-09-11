local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = { "javascript,javascriptreact,typescript,typescriptreact,json", "norg", "cpp,cmake" },
    command = "setlocal sts=2 ts=2 sw=2",
})
