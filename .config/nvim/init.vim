"https://github.com/jakobkhansen"

"Welcome to my personal vimrc, it is the accumulation of Vim usage and
"configuration since early 2019 when I started using Vim." This configuration
"is based around leader mapping, trying to create a Vim configuration you can
"live inside. In March 2021 I switched away from Coc.nvim in favor of Neovim
"builtin LSP. Some configuration is still todo for this to work smoothly.

"Contents"
    "1. Plugins"
    "2. Vim Options"
    "3. Leader maps and which-key config"
    "4. Vim mappings"
    "5. Visuals, colorscheme, Airline ..."
    "6. Plugin configuration"

let mapleader="\<Space>"
let home=$HOME

"Plugins"
    call plug#begin()
        "Plugin dependencies"
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'RishabhRD/popfix'
        Plug 'rbgrouleff/bclose.vim'

        "Text manipulation"
        Plug 'scrooloose/nerdcommenter'
        Plug 'windwp/nvim-autopairs'

        "Movement"
        Plug 'easymotion/vim-easymotion'
        Plug 'psliwka/vim-smoothie'

        "Syntax highlighting"
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'sheerun/vim-polyglot'

        "Buffers"
        Plug 'troydm/zoomwintab.vim'

        "Themes and Visuals"
        Plug 'christianchiarulli/nvcode-color-schemes.vim'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'kyazdani42/nvim-web-devicons'


        "Files and git"
        Plug '907th/vim-auto-save'
        Plug 'tpope/vim-fugitive'
        Plug 'kyazdani42/nvim-tree.lua'
        Plug 'erietz/vim-terminator'

        "Menus"
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'mhinz/vim-startify'
        Plug 'spinks/vim-leader-guide'

        "LSP"
        Plug 'neovim/nvim-lspconfig'
        Plug 'RishabhRD/nvim-lsputils'
        Plug 'hrsh7th/nvim-compe'
        Plug 'mfussenegger/nvim-jdtls'

        "Snippets"
        "Plug 'norcalli/snippets.nvim'
        Plug 'L3MON4D3/LuaSnip'

        "Notes"
        Plug 'reedes/vim-pencil'
        Plug 'instant-markdown/vim-instant-markdown'
        Plug 'lervag/vimtex'

        "Random"
        Plug 'andweeb/presence.nvim'

        


    call plug#end()


"Vim options"
    "Enables various indent settings"
    filetype plugin indent on

    "Disables autofilling comments and similar"
    au FileType * setlocal fo-=c fo-=r fo-=o

	"Indents"
    set smartindent
    set autoindent
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4

    "Buffers"
    set hidden
    set splitbelow
    set splitright

    "Random options"
    set nowrap
    set smartcase
    set ignorecase
    set mouse=a
    set scrolloff=10
    set number
    set relativenumber
    set timeoutlen=600
    

    "Persistent undo"
    let s:undoDir = "/tmp/.undodir_" . $USER
    if !isdirectory(s:undoDir)
        call mkdir(s:undoDir, "", 0700)
    endif
    let &undodir=s:undoDir
    set undofile


"Leader maps and which-key"

    "Lua wrappers"
    command! LspDefinition lua vim.lsp.buf.definition()
    command! LspImplementation lua vim.lsp.buf.implementation()
    command! LspReferences lua vim.lsp.buf.references()
    command! LspRename lua vim.lsp.buf.rename()
    command! LspSignature lua vim.lsp.buf.signature_help()
    command! LspHover lua vim.lsp.buf.hover()

    command! LspCodeAction lua vim.lsp.buf.code_action()
    command! LspCodeActionJava lua require('jdtls').code_action()
    command! LspCodeActionJavaVisual lua require('jdtls').code_action(true)

    command! LspFormat lua vim.lsp.buf.formatting_sync(nil, 100)

    command! LspLineDiagnostics lua vim.lsp.diagnostic.show_line_diagnostics()
    command! LspDiagnosticsNext lua vim.lsp.diagnostic.goto_next()
    command! LspDiagnosticsPrev lua vim.lsp.diagnostic.goto_prev()

    "nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
    let g:which_key_map = {}
    let g:lmap = {}

    "Find x"
    map <Leader>ff <CMD>Telescope find_files prompt_prefix=🔍<CR>
    map <Leader>fh <CMD>Telescope find_files find_command=rg,--files,/home/jakob prompt_prefix=🔍<CR>
    map <Leader>fz <CMD>Telescope find_files find_command=rg,--hidden,--files prompt_prefix=🔍<CR>
    map <Leader>fg <CMD>Telescope git_files prompt_prefix=🔍<CR>
    map <Leader>fc <CMD>Telescope live_grep prompt_prefix=🔍<CR>
    map <leader>fl <CMD>NvimTreeToggle<cr><bar><CMD>NvimTreeToggle<CR><bar><CMD>NvimTreeToggle<CR>


    let g:lmap.f = {'name': 'find'}
    let g:lmap.f.f = 'find-files'
    let g:lmap.f.h = 'find-files-home'
    let g:lmap.f.z = 'find-hidden-files'
    let g:lmap.f.c = 'find-code'
    let g:lmap.f.g = 'find-git-files'
    let g:lmap.f.l = 'file-tree'
    
    "LSP"
    map <silent> <Leader>lh <CMD>LspHover<CR>
    map <silent> <Leader>ls <CMD>LspSignature<CR>
    map <silent> <Leader>ld <CMD>LspDefinition<CR>
    map <silent> <Leader>li <CMD>LspImplementation<CR>
    map <silent> <Leader>lr <CMD>LspReferences<CR>
    map <silent> <Leader>ln <CMD>LspRename<CR>
    nmap <silent> <Leader>la <CMD>LspCodeActionJava<CR>
    vmap <silent> <Leader>la <CMD>LspCodeActionJavaVisual<CR>
    map <silent> <Leader>lf gf
    nmap <silent> <Leader>lp <CMD>LspFormat<CR>
    map <silent> <Leader>led <CMD>Telescope lsp_document_diagnostics<CR>
    map <silent> <Leader>lew <CMD>Telescope lsp_workspace_diagnostics<CR>
    map <silent> <Leader>lel <CMD>LspLineDiagnostics<CR>
    map <silent> <Leader>len <CMD>LspDiagnosticsNext<CR>
    map <silent> <Leader>lep <CMD>LspDiagnosticsPrev<CR>
    imap <silent> <A-Tab> <CMD>LspHover<CR>

    let g:lmap.l = {'name': 'lsp'}
    let g:lmap.l.h = 'show-hover'
    let g:lmap.l.s = 'show-signature'
    let g:lmap.l.d = 'goto-definition'
    let g:lmap.l.i = 'goto-implementation'
    let g:lmap.l.r = 'goto-references'
    let g:lmap.l.n = 'rename-symbol'
    let g:lmap.l.a = 'code-action'
    let g:lmap.l.f = 'goto-file'
    let g:lmap.l.p = 'prettier-format'

    let g:lmap.l.e = {'name': 'diagnostics'}
    let g:lmap.l.e.l = 'line-diagnostics'
    let g:lmap.l.e.d = 'document-diagnostics'
    let g:lmap.l.e.w = 'workspace-diagnostics'
    let g:lmap.l.e.n = 'next-diagnostic'
    let g:lmap.l.e.p = 'prev-diagnostic'

    "Terminal"
    function ToggleTerminal()
        if &buftype ==# 'terminal'
            :bd!
        else
            :bot 15split term://zsh
            :set nobl
            :nnoremap <buffer> <Tab> <Tab>
            :nnoremap <buffer> <S-Tab> <S-Tab>
        endif
    endfunction

    map <silent> <Leader>tt <CMD>call ToggleTerminal()<CR><CMD>set nobl<CR>
    map <silent> <Leader>tv <CMD>vsplit term://zsh<CR>
    map <silent> <Leader>tf <CMD>terminal<CR>
    map <silent> <leader>tr <CMD>TerminatorOpenTerminal<CR><CMD>TerminatorRunFileInTerminal<CR><Esc>:wincmd p<CR>i

    let g:lmap.t = {'name': 'terminal'}
    let g:lmap.t.t = 'mini-terminal'
    let g:lmap.t.v = 'vertical-terminal'
    let g:lmap.t.f = 'full-terminal'
    let g:lmap.t.r = 'terminal-run'

    "Buffers and cwd"
    map <Leader>be <CMD>enew<CR>
    map <Leader>bd <CMD>bn <bar> :bd!#<CR>
    map <Leader>BD <CMD>bd!<CR>
    map <Leader>bx <CMD>close<CR>
    map <Leader>bc <CMD>cd %:p:h<CR>
    map <Leader>bv <CMD>vsplit<CR>
    map <Leader>bh <CMD>split<CR>
    map <Leader>bo <CMD>ZoomWinTabToggle<CR>

    let g:lmap.b = {'name': 'buffer'}
    let g:lmap.b.d = 'buffer-delete'
    let g:lmap.b.x = 'buffer-close'
    let g:lmap.b.v = 'vertical-split'
    let g:lmap.b.h = 'horizontal-split'
    let g:lmap.b.e = 'open-empty-buffer'
    let g:lmap.b.c = 'set-cwd'
    let g:lmap.b.o = 'toggle-fullscreen'

    "Git"
    map <Leader>gc <CMD>Telescope git_commits prompt_prefix=🔍<CR>
    map <Leader>gb <CMD>Telescope git_branches prompt_prefix=🔍<CR>
    map <Leader>gh <CMD>Git blame<CR>
    map <Leader>gd <CMD>Git diff<CR>
    map <Leader>gm <CMD>Git mergetool<CR>
    map <Leader>gs <CMD>G<CR>
    map <Leader>gb <CMD>silent !gh repo view --web<CR>

    let g:lmap.g = {'name': 'git'}
    let g:lmap.g.c = 'git-commits'
    let g:lmap.g.b = 'git-branch'
    let g:lmap.g.h = 'git-blame'
    let g:lmap.g.d = 'git-diff'
    let g:lmap.g.m = 'git-mergetool'
    let g:lmap.g.s = 'git-status'
    let g:lmap.g.b = 'git-browser'


    "Help"
    map <silent> <Leader>ht <CMD>Telescope help_tags prompt_prefix=🔍<CR>
    map <silent> <Leader>hm <CMD>Telescope man_pages prompt_prefix=🔍<CR>
    map <silent> <Leader>hw <CMD>execute "h " . expand("<cword>")<CR>

    let g:lmap.h = {'name': 'help'}
    let g:lmap.h.t = 'help-tags'
    let g:lmap.h.m = 'man-pages'
    let g:lmap.h.w = 'help-cword'

    "Not categorized"
    noremap<Leader>no <CMD>nohlsearch<CR>
    let g:lmap.n = {'name': 'leader_ignore'}
    let g:lmap.n.o = 'leader_ignore'

    let g:lmap.s = {'name': 'leader_ignore'}
    let g:lmap.s.s = 'leader_ignore'
    let g:lmap.B = {'name': 'leader_ignore'}
    let g:lmap.B.D = 'leader_ignore'

    let g:lmap["<BS>"] = 'leader_ignore'


    call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
    nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>


"Vim Bindings"
    "Remaps"
    noremap + $
    noremap "" "+y
    map <F1> <Esc>
    map <LeftMouse> <Nop>
    imap <LeftMouse> <Nop>


    "Movement"
    nmap <silent> K 10k
    nmap <silent> J 10j
    vmap <silent> K 10k
    vmap <silent> J 10j

    noremap <silent> ; ,
    noremap <silent> , ;

    "Text manipulation"
    nnoremap <silent> Q gqap

    "Move lines"
    nnoremap <A-k> :m-2<CR>==
    nnoremap <A-j> :m+<CR>==

    "Buffers and tabs"
    nmap <Tab> <CMD>bn<CR>
    nmap <S-Tab> <CMD>bp<CR>
    map <A-Tab> <CMD>
    nnoremap <F5> :%bd!<bar>e#<bar>bd!#<CR>
    nnoremap <F6> :bufdo bwipeout!<CR>
    map <Leader><BS> <CMD>cd ..<CR>
        
    noremap <C-h> <C-w>h
    noremap <C-j> <C-w>j
    noremap <C-k> <C-w>k
    noremap <C-l> <C-w>l

    noremap <C-M-h> <CMD>vertical resize-5<CR>
    noremap <C-M-j> <CMD>resize-5<CR>
    noremap <C-M-k> <CMD>resize+5<CR>
    noremap <C-M-l> <CMD>vertical resize+5<CR>
    noremap <C-M-r> <C-W>=

    noremap zh 10zh
    noremap zl 10zl

    function! TabCloseRight(bang)
        let cur=tabpagenr()
        while cur < tabpagenr('$')
            exe 'tabclose' . a:bang . ' ' . (cur + 1)
        endwhile
    endfunction

    function! TabCloseLeft(bang)
        while tabpagenr() > 1
            exe 'tabclose' . a:bang . ' 1'
        endwhile
    endfunction

    "Delete all buffers to the left and right"
    map <F2> <CMD>2,-1bufdo bd!<CR>
    map <F3> <CMD>+1,$bufdo bd!<CR>


    "Terminal"
    tnoremap <silent> <C-q> <Esc>

    tnoremap <silent> <Esc> <C-\><C-n>

    "Set Neovim dir to terminal dir"
    au TermOpen * map <buffer> <Leader>bc ipwd\|xclip -selection clipboard<CR><C-\><C-n>:cd <C-r>+<CR>i
    au TermOpen * map <buffer> <Leader>bd <CMD>call ToggleTerminal()<CR>


    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l

    tnoremap <C-M-h> <C-\><C-N><CMD>vertical resize-5<CR>i
    tnoremap <C-M-j> <C-\><C-N><CMD>resize-5<CR>i
    tnoremap <C-M-k> <C-\><C-N><CMD>resize+5<CR>i
    tnoremap <C-M-l> <C-\><C-N><CMD>vertical resize+5<CR>i
    tnoremap <C-M-r> <C-\><C-N><C-W>=i



    au TermOpen * startinsert

    "Commands"
    command! Fp :echo expand('%:p')


"Visuals, colorscheme, Airline"
    "Colorscheme"
    set termguicolors
    set signcolumn=no
    colorscheme onedark

    "Transparent background / Same background as terminal
    hi Normal guibg=NONE ctermbg=NONE

    "Hide end of line symbol"
    set fcs=eob:\ 

    "Airline"
    let g:airline_theme = "onedark"
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    "Show terminals in airline tabline"
    let g:airline#extensions#tabline#ignore_bufadd_pat = '!|defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'


"Plugin configuration"
    "Easymotion"
    map s <plug>(easymotion-bd-f)
    map S <plug>(easymotion-bd-f2)
    let g:EasyMotion_smartcase = 1
    let g:EasyMotion_do_mapping = 0

    "Auto-save"
    let g:auto_save = 1
    let g:auto_save_silent = 1
    let g:auto_save_events = ["CursorHold", "InsertLeave", "TextChanged"]

    "Nerd commenter"
    noremap # :call NERDComment(0, "toggle")<CR>
    let g:NERDCreateDefaultMappings = 0

    "Nvim-tree"
    let g:nvim_tree_auto_close = 1
    let g:nvim_tree_ignore = [ '*.class', '*.pdf' ]
    let g:nvim_tree_quit_on_open = 1
    let g:nvim_tree_hide_dotfiles = 1
    luafile $HOME/.config/nvim/lua/nvim-tree-config.lua

    "Telescope"
    luafile /home/jakob/.config/nvim/lua/telescope-config.lua
    "Telescope (or LSP?) randomly fucks with number and signcolumn
    au BufAdd,BufCreate,BufNew * set number
    au BufAdd,BufCreate,BufNew * set relativenumber
    au BufAdd,BufCreate,BufNew * set signcolumn=no

    "Ranger"
    let g:ranger_map_keys = 0

    "LSP"
    luafile $HOME/.config/nvim/lua/lsp-servers.lua
    luafile $HOME/.config/nvim/lua/lsp-config.lua
    luafile $HOME/.config/nvim/lua/lsputils-config.lua

    "Make sure that cwd is the file before starting server
    function! s:java_start_lsp()
        cd %:p:h
        lua start_jdt()
    endfunction
    "map <Leader>jls <CMD>sleep 1000m<bar>lua start_jdt()<CR>
    au FileType java call s:java_start_lsp()

    "Nvim-compe"
    set completeopt=menuone,noselect
    set pumheight=10
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    
    luafile $HOME/.config/nvim/lua/nvim-compe-config.lua

    "Nvim-autopairs"
    luafile $HOME/.config/nvim/lua/nvim-autopairs-config.lua

    "Treesitter"
    luafile $HOME/.config/nvim/lua/treesitter-config.lua

    "LuaSnip"
    luafile $HOME/.config/nvim/lua/luasnips.lua

    snoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
    snoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>

    imap <silent> <C-k> <CMD>lua require'luasnip'.jump(1)<CR>
    inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>


    "Bclose"
    let g:bclose_no_plugin_maps = v:true


    "Startify"
    map <Leader>ss <CMD>Startify<CR>
    let g:startify_files_number = 5
    function! s:configFiles()
        let files = [
            \ {'line': 'vim', 'path': '$MYVIMRC'},
            \ {'line': 'bashrc', 'path': '$HOME/.bashrc'},
            \ {'line': 'bash aliases', 'path': '$HOME/.bash_aliases'},
            \ {'line': 'i3', 'path': '$HOME/.config/i3/config'},
            \ {'line': 'ranger', 'path': '$HOME/.config/ranger/rc.conf'},
            \ {'line': 'kitty', 'path': '$HOME/.config/kitty/kitty.conf'},
            \ {'line': 'polybar', 'path': '$HOME/.config/polybar/config'},
            \ {'line': 'compton', 'path': '$HOME/.config/compton/compton.conf'},
        \ ]

        return files
    endfunction

    function! s:oftenUsed()
        let files = [
            \ {'line': 'TODO', 'cmd': 'edit $HOME/Documents/TODO.md'},
            \ {'line': 'IN3050', 'cmd': 'cd $HOME/Documents/School/IN3050/'},
            \ {'line': 'IN3030', 'cmd': 'cd $HOME/Documents/School/IN3030/'},
            \ {'line': 'IN3020', 'cmd': 'cd $HOME/Documents/School/IN3020/'},
            \ {'line': 'Neovim', 'cmd': 'cd $HOME/.config/nvim/'},
            \ {'line': 'Kattis', 'cmd': 'cd $HOME/Documents/Personal/KattisSolutions'},
        \]
        return files
    endfunction
    
    function! s:luaFiles()
        let files = systemlist('ls $HOME/.config/nvim/lua')
        return map(files, "{'line': v:val, 'path': '$HOME/.config/nvim/lua/'. v:val}")
    endfunction

    let g:startify_commands = [
        \ ['Reload Vim', 'source $MYVIMRC'],
        \ ['Update plugins', 'PlugUpdate']
    \ ]

    let g:startify_lists = [
    \ { 'type': 'files', 'header': ['   Recent'] },
    \ { 'type': function('s:oftenUsed'), 'header': ['   Often used'], 'indices': ['todo', '3050', '3030', '3020'] },
    \ { 'type': function('s:configFiles'), 'header': ['   Config files'], 'indices': ['cv', 'cb', 'ca', 'ci', 'cr', 'ck', 'cp', 'co'] },
    \ { 'type': 'commands', 'header': ['   Commands'], 'indices': ['cs', 'pu'] },
    \ { 'type': function('s:luaFiles'), 'header': ['   Lua files'] },
    \ ]

    "Terminator"
    command! RunTerminal <CMD>TerminatorOpenTerminal<CR><CMD>TerminatorRunFileInTerminal<CR>
    let g:terminator_clear_default_mappings = "foo bar"


    "Vim-leader-guide"
    let g:leaderGuide_display_plus_menus = 1
    let g:leaderGuide_vertical = 0
    let g:leaderGuide_position = 'botleft'
    let g:leaderGuide_hspace = 5

    "Vimtex"
    augroup tex
        autocmd FileType tex set textwidth=89
				au FileType tex set conceallevel=2
    augroup END

    au BufReadPost,BufNewFile *.tex :VimtexCompile
    let g:tex_flavor = "latex"
    let g:vimtex_quickfix_open_on_warning = 0
    let g:vimtex_compiler_latexmk = { 
    \ 'executable' : 'latexmk',
    \ 'options' : [ 
    \   '-pdflatex=lualatex',
    \   '-lualatex',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}


    "Markdown"
    let g:pencil#textwidth = 90
    let g:instant_markdown_autostart = 0
    let g:instant_markdown_autoscroll = 1
    let g:instant_markdown_allow_unsafe_content = 1
    let g:instant_markdown_mathjax = 1
    let g:vim_markdown_math = 1


    augroup markdown
      au FileType markdown command! Preview call MarkdownPreview()
      au FileType markdown command! PreviewStop :InstantMarkdownStop
      au FileType markdown command! PreviewPDF call CompileMarkdownPDF()
      au FileType markdown call pencil#init({'wrap': 'hard', 'autoformat': 0})
      au FileType markdown command! -nargs=1 Img call MarkdownImage(<f-args>)
      au FileType markdown set conceallevel=2
    augroup END


    function MarkdownImage(filename)
        silent !mkdir images > /dev/null 2>&1
        let imageName = ("images/" . expand('%:t:h') . "_" . a:filename . ".png")
        silent execute "!scrot -a $(slop -f '\\\%x,\\\%y,\\\%w,\\\%h') --line style=solid,color='white' " . imageName

        silent execute "normal! i<center>![Image](" . imageName . ")</center>"
    endfunction

    function MarkdownPreview()
        silent! :InstantMarkdownStop
        silent! :InstantMarkdownPreview
    endfunction

    "Polyglot weird stuff"
    let g:python_highlight_space_errors = v:false
    hi clear Conceal
