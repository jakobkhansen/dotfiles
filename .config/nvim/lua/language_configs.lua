local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = { "javascript,javascriptreact,typescript,typescriptreact,json,css", "norg", "cpp,cmake" },
    command = "setlocal sts=2 ts=2 sw=2",
})

autocmd("BufRead,BufNewFile", {
    pattern = { "*.mdx" },
    command = "setlocal ft=mdx",
})
