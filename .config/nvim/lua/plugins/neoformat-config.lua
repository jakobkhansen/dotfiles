
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
vim.g.neoformat_enabled_cpp = {'astyle'}

vim.g.neoformat_cpp_astyle = {
    exe = 'astyle',
    args = {
        '--mode=c',
        '--indent-classes',
        '--indent=spaces=2',
        '--style=attach',
    },
    stdin = 1
}
