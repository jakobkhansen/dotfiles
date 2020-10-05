"https://github.com/jakobkhansen"

"Welcome to my personal vimrc, it is the accumulation of vim usage and configuration"
"since early 2019 when I started using Vim."
"I try to use few plugins, and base this configuration mostly around Coc.nvim and its extensions."
"My Coc.nvim settings.json file can be found in my dotfiles repo."

"Contents"
    "1. Plugins"
    "2. Syntax and highlighting"
    "3. File management, saving, undo, ..."
    "4. Global hotkeys"
    "5. Language specific configurations and hotkeys"
    "6. Coc.nvim autocompletion config"
    "7. Visuals, colorscheme, airline"

"Plugins"
    call plug#begin()

    "Syntax and text manipulation"
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-surround'
    Plug 'jaxbot/selective-undo.vim'
    Plug 'chemzqm/vim-jsx-improve'
    Plug 'alvan/vim-closetag'

    "Visual"
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "Themes"
    Plug 'whatyouhide/vim-gotham'
    Plug 'morhetz/gruvbox'
    Plug 'ayu-theme/ayu-vim'

    "Files and Git"
    Plug 'ryanoasis/vim-devicons'
    Plug '907th/vim-auto-save'
    Plug 'mhinz/vim-startify'
    Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
    Plug 'tpope/vim-fugitive'


    "Languages / intellisense"
    Plug 'sheerun/vim-polyglot'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'lervag/vimtex'
    let g:coc_global_extensions = [
                \"coc-snippets",
                \"coc-explorer",
                \"coc-marketplace",
                \"coc-discord",
                \"coc-vimtex",
                \"coc-tsserver",
                \"coc-tslint-plugin",
                \"coc-python",
                \"coc-json",
                \"coc-java",
                \"coc-html",
                \"coc-css",
                \"coc-pairs"
                \]

    "Random"
    Plug 'vim-scripts/uptime.vim'

    call plug#end() 

"Syntax and highlighting"
    filetype plugin indent on
    set signcolumn=yes

    "Scrolling, mouse, line numbers, folds, ..."
    set number
    set hidden
    set mouse=a
    autocmd BufNewFile,BufRead *.txt,*.tex,*.md set tw=89
    set foldmethod=indent
    set foldlevelstart=99
    set scrolloff=10
    set nowrap

    "Tabs"
    set autoindent
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    autocmd Filetype dart setlocal tabstop=2
    autocmd Filetype dart setlocal shiftwidth=2
    autocmd Filetype dart setlocal softtabstop=2

    "Syntax"
    set nocompatible     
    syntax on
    filetype on
    filetype indent on
    filetype plugin on
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    set ignorecase

    augroup dynamic_smartcase
        autocmd!
        autocmd CmdLineEnter : set nosmartcase
        autocmd CmdLineLeave : set smartcase
    augroup END

    "Splits"
    set splitbelow
    set splitright

    "Close tags"  
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx"

    "Gradle Groovy syntax"
    au BufNewFile,BufRead *.gradle setf groovy


"File management, saving, undo, ..."
    "Autosave"
    let g:auto_save = 1
    let g:auto_save_events = ["InsertLeave", "TextChanged"]

    "Persistent undo
    let s:undoDir = "/tmp/.undodir_" . $USER
    if !isdirectory(s:undoDir)
        call mkdir(s:undoDir, "", 0700)
    endif
    let &undodir=s:undoDir
    set undofile

"Global hotkeys"

    "Remaps"
    nnoremap + $
    vnoremap + $
    nnoremap "" "+y
    vnoremap "" "+y
    map $ <Nop>

    "Lines and navigation"
    map <ScrollWheelUp> <C-Y>
    map <ScrollWheelDown> <C-E>

    nmap <LeftMouse> <nop>
    imap <LeftMouse> <nop>
    vmap <LeftMouse> <nop>

    nnoremap <silent> <C-U> 10k
    nnoremap <silent> <C-D> 10j
    vnoremap <silent> <C-U> 10k
    vnoremap <silent> <C-D> 10j

    "Move lines"
    nnoremap <A-k> :m-2<CR>==
    nnoremap <A-j> :m+<CR>==


    "Toggle comments"
    noremap # :call NERDComment(0, "toggle")<CR>

    "Toggle folds with mouse"
    :noremap <3-LeftMouse> za

    "Move between buffers"
    nnoremap  <silent> <tab> :bn<CR> 
    nnoremap  <silent> <s-tab> :bp<CR>

    "Delete all other buffers"
    nnoremap <F5> :%bd<bar>e#<bar>bd#<CR>

    "Backspace behavior"
    set backspace=indent,eol,start

    "No idea"
    autocmd InsertLeave * execute 'normal! mo'

    "Show codeaction on *"
    nmap <silent> * <Plug>(coc-codeaction)


    "Arrows"
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>

    "Rename, implementation, definition..."
    nmap <silent> gd :call <SID>show_documentation()<CR>
    nmap <silent> gD <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gn <Plug>(coc-rename)

    "Fzf Search"
    nmap <A-s> :GFiles<CR>
    nmap <A-s-s> :Files<CR>
    nmap <A-c> :Ag<CR>

    "coc-explorer"
    nmap <C-n> :CocCommand explorer<CR>

"Language specific configurations and hotkeys"

    "Python"
    let g:python_highlight_all = 0

    "Java"
    autocmd FileType java let java_highlight_functions = 1

    "Latex"
    au BufReadPost,BufNewFile *.tex :VimtexCompile
    let g:vimtex_quickfix_latexlog = {'default' : 0}
    autocmd FileType tex imap <buffer> bullet<Tab> \begin{itemize}<CR>\item <CR><Backspace><Backspace>\end{itemize}<Up>
    let g:tex_flavor = "latex"
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

    "Ruby"
    let g:ruby_host_prog = '/usr/lib64/ruby/gems/2.5.0/gems/neovim-0.8.0/exe/neovim-ruby-host'

    "Markdown"
    augroup markdown
      au FileType markdown command! Preview :!zathura /tmp/%.pdf &
      au FileType markdown command! SavePDF :!pandoc % -t pdf -o ./%.pdf --pdf-engine=xelatex -V mainfont="Unifont" &
      au BufNewFile,BufRead *.md silent! !pandoc % -t pdf -o /tmp/%.pdf --pdf-engine=xelatex -V mainfont="Unifont" &
      au BufWritePost *.md silent! !pandoc % -t pdf -o /tmp/%.pdf --pdf-engine=xelatex -V mainfont="Unifont" &
      au BufNewFile,BufRead *.md set tw=89
    augroup END

"Coc.nvim autocomplete"

    "Tab completion"
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    "Enter completion"
    if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    "Enter indent on pair"
     inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    set cmdheight=2


"Visuals, colorscheme, Airline"

    "Colorscheme"
    set t_Co=256
    set background=dark
    set termguicolors
    set signcolumn=no
    colorscheme gotham
    highlight CocWarningSign guifg=#195466
    highlight CocWarningSign guibg=#11151c
    set fcs=eob:\ 
    hi Normal guibg=NONE ctermbg=NONE

    "Airline"
    let g:airline_theme = "ayu_mirage"
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
