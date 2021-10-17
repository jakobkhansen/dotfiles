
vim.g.neoformat_basic_format_retab = 1

vim.g.neoformat_latex_latexindent = {
    exe = 'latexindent',
    stdin = 1
}

vim.g.neoformat_java_prettier = {
    exe = 'prettier',
    args = {
        '--tab-width 4',
        '--stdin-filepath',
        '"%:p"',
    },
    stdin = 1
}

vim.g.neoformat_enabled_java = {'prettier'}
