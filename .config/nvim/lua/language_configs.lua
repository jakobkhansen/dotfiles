local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = { "javascript,javascriptreact,typescript,typescriptreact,json,css", "norg", "cpp,cmake" },
    command = "setlocal sts=2 ts=2 sw=2",
})


-- MDX
autocmd("BufRead,BufNewFile", {
    pattern = { "*.mdx" },
    command = "setlocal ft=markdown",
})

-- Kompis
autocmd("BufRead,BufNewFile", {
    pattern = { "*.kp" },
    command = "setlocal ft=kompis",
})

autocmd("BufRead,BufNewFile", {
    pattern = { "*.kp" },
    command = "setlocal cindent",
})

autocmd("FileType", {
    pattern = { "kompis" },
    command = "setlocal sts=4 ts=4 sw=4",
})
