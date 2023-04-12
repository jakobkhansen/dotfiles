local autocmd = vim.api.nvim_create_autocmd

local vimtex_running = false
autocmd({ "BufReadPost" }, {
    pattern = "*.tex",
    callback = function()
        if vimtex_running == false then
            vim.cmd("VimtexCompile")

            vimtex_running = true
        end
    end,
})

vim.g.vimtex_fold_enabled = true
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_forward_search_on_start = false
vim.g.vimtex_quickfix_mode = 0

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
