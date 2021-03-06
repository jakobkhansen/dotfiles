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
    "6. Plugin configuration"
    "7. Visuals, colorscheme, airline"

let mapleader="\<Space>"
"Plugins"
    call plug#begin()

    "Needed utils for snipmate"
    Plug 'marcweber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'

    "Syntax, text manipulation and movement"
    Plug 'scrooloose/nerdcommenter'
    Plug 'alvan/vim-closetag'
	Plug 'easymotion/vim-easymotion'
    Plug 'psliwka/vim-smoothie'

    "Visual"
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "Themes"
    Plug 'whatyouhide/vim-gotham'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'

    "Files and Git"
    Plug '907th/vim-auto-save'
    Plug 'tpope/vim-fugitive'

    "Languages / intellisense, snippets"
    Plug 'sheerun/vim-polyglot'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'lervag/vimtex'
    Plug 'garbas/vim-snipmate'
    Plug 'chemzqm/vim-jsx-improve'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = [
                \"coc-snippets",
                \"coc-explorer",
								\"coc-discord",
                \"coc-vimtex",
                \"coc-tsserver",
                \"coc-pyright",
                \"coc-json",
                \"coc-java",
                \"coc-html",
                \"coc-css",
                \"coc-pairs",
                \"coc-kotlin"
                \]

    "Telescope"
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    "Notes"
    Plug 'suan/vim-instant-markdown'
    Plug 'reedes/vim-pencil'


    "Random"
    Plug 'vim-scripts/uptime.vim'
    Plug 'wfxr/minimap.vim'
		Plug 'liuchengxu/vim-which-key'

    call plug#end() 



    luafile ~/.config/nvim/lua/treesitter-config.lua

"Syntax and highlighting"
    filetype plugin indent on
    set signcolumn=yes

    "Scrolling, mouse, line numbers, folds, ..."
    set number
    set hidden
    set mouse=a


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
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx,*.js,*.ts"

    "Gradle Groovy syntax"
    au BufNewFile,BufRead *.gradle setf groovy


"File management, saving, undo, ..."
    "Autosave"
    let g:auto_save = 1
    let g:auto_save_silent = 1
    let g:auto_save_events = ["CursorHold", "InsertLeave", "TextChanged"]
    "let updatetime = 50


    "Persistent undo
    let s:undoDir = "/tmp/.undodir_" . $USER
    if !isdirectory(s:undoDir)
        call mkdir(s:undoDir, "", 0700)
    endif
    let &undodir=s:undoDir
    set undofile





"Global hotkeys"

	"Leader maps"
    noremap<Leader>no <CMD>nohlsearch<CR>

    map <Leader>ff <CMD>Telescope find_files<CR>
    map <Leader>fg <CMD>Telescope git_files<CR>
    map <Leader>fc <CMD>Telescope live_grep<CR>
    map <Leader>ft <CMD>Telescope builtin<CR>

    map <Leader>gc <CMD>Telescope git_commits<CR>
    map <Leader>gb <CMD>Telescope git_branches<CR>
    map <Leader>gh <CMD>Git blame<CR>
    map <Leader>gd <CMD>Git diff<CR>
    map <Leader>gm <CMD>Git mergetool<CR>

    map <Leader>be <CMD>enew<CR>
    map <Leader>bd <CMD>bd<CR>
    map <Leader>bD :bn <bar> :bd#<CR>

    map <silent> <Leader>ls :call <SID>show_documentation()<CR>
    map <silent> <Leader>ld <Plug>(coc-definition)
    map <silent> <Leader>lt <Plug>(coc-type-definition)
    map <silent> <Leader>li <Plug>(coc-implementation)
    map <silent> <Leader>lr <Plug>(coc-references)
    map <silent> <Leader>ln <Plug>(coc-rename)
    map <silent> <Leader>la <Plug>(coc-codeaction)

    map <silent> gd :call <SID>show_documentation()<CR>

    "Remaps"
    nnoremap + $
    vnoremap + $
    nnoremap "" "+y
    vnoremap "" "+y
    map $ <Nop>
    map <F1> <Esc>
    imap <F1> <Esc>

    "Lines and navigation"

    nmap <LeftMouse> <nop>
    imap <LeftMouse> <nop>
    vmap <LeftMouse> <nop>

    nmap <silent> K 10k
    nmap <silent> J 10j
    vmap <silent> K 10k
    vmap <silent> J 10j

    "Move lines"
    nnoremap <A-k> :m-2<CR>==
    nnoremap <A-j> :m+<CR>==

    "Search"


    "Toggle comments"
    noremap # :call NERDComment(0, "toggle")<CR>

    "Toggle folds with mouse"
    :noremap <3-LeftMouse> za

    "Move between buffers"
    nnoremap  <silent> <tab> :bn<CR> 
    nnoremap  <silent> <s-tab> :bp<CR>

    "Move between splits"
    noremap <C-h> <C-w>h
    noremap <C-j> <C-w>j
    noremap <C-k> <C-w>k
    noremap <C-l> <C-w>l


    "Backspace behavior"
    set backspace=indent,eol,start

    "No idea"
    autocmd InsertLeave * execute 'normal! mo'



    "Telescope"
    command! ManP :Telescope man_pages

    "Random buffer convenience"
    nnoremap <F5> :%bd<bar>e#<bar>bd#<CR>
    nnoremap <F6> :bufdo bwipeout<CR>




    "Arrows"
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>

    "Rename, implementation, definition..."


    "coc-explorer"
    nmap <silent> <C-n> :CocCommand explorer<CR>


"Language specific configurations and hotkeys"

    "Pencil" 
    let g:pencil#textwidth = 89
    let g:pencil#conceallevel = 0

    "Python"
    let g:python_highlight_all = 0

    "Java"
    au FileType java command! JavaClean :CocCommand java.clean.workspace
    

    "Latex"

    augroup tex
        autocmd FileType tex set textwidth=89
				au FileType tex set conceallevel=2
    augroup END

    au BufReadPost,BufNewFile *.tex :VimtexCompile
    "let g:vimtex_quickfix_latexlog = {'default' : 0}
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


    "Markdown and text"
    let g:instant_markdown_autostart = 0
    let g:instant_markdown_autoscroll = 1
    let g:instant_markdown_allow_unsafe_content = 1
    let g:instant_markdown_mathjax = 1
    let g:vim_markdown_math = 1


    let g:vim_markdown_new_list_item_indent = 0

    nnoremap <silent> Q gqap

    augroup markdown
      au FileType markdown command! Preview call MarkdownPreview()
      au FileType markdown command! PreviewStop :InstantMarkdownStop
      au FileType markdown command! PreviewPDF call CompileMarkdownPDF()
      au FileType markdown call pencil#init({'wrap': 'soft', 'autoformat': 0})
      au FileType markdown command! -nargs=1 Img call MarkdownImage(<f-args>)
      au FileType markdown command! Table :TableModeToggle
      au FileType markdown set conceallevel=2
    augroup END

    augroup text
      au FileType text call pencil#init({'wrap': 'soft', 'autoformat': 0})
    augroup END



		"So proud of this, instant image screenshot into markdown"
    function MarkdownImage(filename)
        silent !mkdir images > /dev/null 2>&1
        let imageName = ("images/" . expand('%:r') . "_" . a:filename . ".png")
        silent execute "!scrot -a $(slop -f '\\\%x,\\\%y,\\\%w,\\\%h') --line style=solid,color='white' " . imageName

        silent execute "normal! i<center>![Image](" . imageName . ")</center>"
    endfunction

    function MarkdownPreview()
        silent! :InstantMarkdownStop
        silent! :InstantMarkdownPreview
    endfunction

    function CompileMarkdownPDF()
        silent! :!pandoc % -t pdf -o ./%.pdf --pdf-engine=xelatex -V mainfont="Unifont"
        silent! :!zathura ./%.pdf &
    endfunction


"Plugin configuration"

    "Coc.nvim"
        "Tab completion"
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        "Enter completion if selected and indent on pair"
         inoremap <silent><expr> <cr> pumvisible() ? complete_info()["selected"] != "-1" ? coc#_select_confirm() : "<CR>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
            else
                call CocAction('doHover')
            endif
        endfunction

        set cmdheight=2
        set pumheight=15

        "Snippets"
        let g:coc_snippet_next = '<c-k>'

        let g:coc_snippet_prev = '<c-j>'

				"Snipmate"
				let g:snipMate = { 'snippet_version' : 1 }

				"Easymotion"
				nmap s <Plug>(easymotion-overwin-f2)
				nmap S <Plug>(easymotion-overwin-f)
				let g:EasyMotion_smartcase = 1


        "Telescope"
				luafile /home/jakob/.config/nvim/lua/telescope-config.lua

				"Treesitter"
				luafile ~/.config/nvim/lua/treesitter-config.lua

        "Minimap"
        nnoremap <leader>mm :MinimapToggle<CR>
        let g:minimap_width = 15

        "Which-key"

        nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

        let g:which_key_map = {}

        let g:which_key_map.l = {
        \ 'name' : '+lsp',
        \ 's' : [':call <SID> show_documentation()', 'show-signature'],
        \ 'd' : ['<Plug>(coc-definition)', 'goto-definition'],
        \ 't' : ['<Plug>(coc-type-definition)', 'goto-type-defintion'],
        \ 'i' : ['<Plug>(coc-implementation)', 'goto-implementation'],
        \ 'r' : ['<Plug>(coc-references)', 'goto-references'],
        \ 'n' : ['<Plug>(coc-rename)', 'rename-symbol'],
        \ 'a' : ['<Plug>(coc-action)', 'code-action'],
        \ }

        let g:which_key_map.f = {
        \ 'name' : '+find',
        \ 'f' : ['<CMD>Telescope find_files', 'find-files'],
        \ 'c' : ['<CMD> Telescope live_grep', 'find-code'],
        \ 'g' : ['<CMD> Telescope git_files', 'find-git-files'],
        \ 't' : ['<CMD> Telescope builtin', 'find-telescope-builtin'],
        \}

        let g:which_key_map.g = {
        \ 'name' : '+git',
        \ 'c' : ['<CMD> Telescope git_commits', 'git-commits'],
        \ 'b' : ['<CMD> Telescope git_branches', 'git-branch'],
        \ 'h' : ['Git blame', 'git-blame'],
        \ 'd' : ['Git diff', 'git-diff'],
        \ 'm' : ['Git mergetool', 'git-mergetool'],
        \}

        let g:which_key_map.b = {
        \ 'name' : '+buffer' ,
        \ 'd' : [':bd', 'close-file'],
        \ 'D' : [':command! BW :bn|:bd#', 'delete-buffer'],
        \ 'v' : [':vsplit', 'vertical-split'],
        \ 'h' : [':split', 'horizontal-split'],
        \ 'e' : [':enew', 'open-empty-buffer'],
        \ }

        let g:which_key_map.m = {'name' : 'which_key_ignore'}
        let g:which_key_map.n = {'name' : 'which_key_ignore'}

        call which_key#register('<Space>', "g:which_key_map")

        "NerdCommenter"
        let g:NERDCreateDefaultMappings = 0


"Visuals, colorscheme, Airline"

    "Colorscheme"
    "set t_Co=256
    "set background=dark
    set termguicolors
    set signcolumn=no
    colorscheme onedark
    highlight CocWarningSign guifg=#4B5263
    set fcs=eob:\ 
    hi Normal guibg=NONE ctermbg=NONE

    "Airline"
    let g:airline_theme = "onedark"
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    hi clear Conceal

