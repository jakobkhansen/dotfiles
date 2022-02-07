local vimscript = vim.api.nvim_exec

vim.g.instant_markdown_autostart = 0
vim.g.instant_markdown_allow_unsafe_content = 1
vim.g.instant_markdown_mathjax = 1
vim.g.vim_markdown_math = 1
vim.g.instant_markdown_mermaid = 1

function _G.MarkdownPreview()
    vimscript('silent! :InstantMarkdownStop', false)
    vimscript('silent! :InstantMarkdownPreview', false)
end

vimscript([[
    function MarkdownImage(filename)
        silent !mkdir images > /dev/null 2>&1
        let imageName = ("images/" . expand('%:t:h') . "_" . a:filename . ".png")
        silent execute "!scrot -a $(slop -f '\\\%x,\\\%y,\\\%w,\\\%h') --line style=solid,color='white' " . imageName

        silent execute "normal! i<center>\n\n![Image](" . imageName . ")\n\n</center>"
    endfunction
]], false)

vimscript('au FileType markdown command! Preview :lua MarkdownPreview()', false)
vimscript('au FileType markdown command! PreviewStop :lua InstantMarkdownStop', false)
vimscript('au FileType markdown setlocal conceallevel=2', false)
vimscript('au FileType markdown setlocal wrap', false)
vimscript('au FileType markdown setlocal tw=0', false)
vimscript('au FileType markdown command! -nargs=1 Img call MarkdownImage(<f-args>)', false)


