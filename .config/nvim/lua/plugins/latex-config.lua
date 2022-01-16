local vimscript = vim.api.nvim_exec

vimscript('au BufReadPost,BufNewFile *.tex :VimtexCompile', false)

vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_compiler_latexmk = {
    executable = 'latexmk',
    options = {
      --'-pdflatex=lualatex',
      --'-lualatex',
      '-file-line-error',
      '-synctex=1',
      '-interaction=nonstopmode',
    },
}
