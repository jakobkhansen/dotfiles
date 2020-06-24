call plug#begin()

"Syntax"
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'

"Visual"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hugolgst/vimsence'

"Themes"
Plug 'whatyouhide/vim-gotham'
Plug 'ayu-theme/ayu-vim'
Plug 'flrnd/plastic.vim'

"Files"
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug '907th/vim-auto-save'
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }

"Languages / intellisense"
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'lervag/vimtex'

"Random"
Plug 'vim-scripts/uptime.vim'

call plug#end() 

filetype plugin indent on
set signcolumn=yes
autocmd FileType tagbar,nerdtree setlocal signcolumn=no

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

"Lines and navigation"
set number
set hidden
set mouse=a
autocmd BufNewFile,BufRead *.txt,*.tex set tw=89
set foldmethod=indent
set foldlevelstart=99
set scrolloff=4

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

nmap <LeftMouse> <nop>
imap <LeftMouse> <nop>
vmap <LeftMouse> <nop>

nnoremap <silent> <C-U> 10k
nnoremap <silent> <C-D> 10j
vnoremap <silent> <C-U> 10k
vnoremap <silent> <C-D> 10j

nnoremap <A-k> :m-2<CR>==
nnoremap <A-j> :m+<CR>==

noremap # :call NERDComment(0, "toggle")<CR>

nnoremap  <silent>   <tab> :bn<CR> 
nnoremap  <silent> <s-tab> :bp<CR>

set backspace=indent,eol,start

"Autosave"
let g:auto_save = 1
"let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]

"Persistent undo
let s:undoDir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
    call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile

"Vimtex"
au BufReadPost,BufNewFile *.tex :VimtexCompile
"let g:vimtex_quickfix_open_on_warning = 0"
let g:vimtex_quickfix_latexlog = {'default' : 0}

"Splits"
set splitbelow
set splitright

"Arrows"
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

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

"Global hotkeys"
nnoremap <buffer> <F7> :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nmap <F25> :bufdo bd<CR>
autocmd InsertLeave * execute 'normal! mo'
nmap <silent> * <Plug>(coc-codeaction)
autocmd CursorHold * if ! coc#util#has_float() | call CocActionAsync('doHover') | endif
set updatetime=2000

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)

"Search"
nmap <A-s> :GFiles<CR>
nmap <A-s-s> :Files<CR>
nmap <A-c> :Ag<CR>


"Python"
let g:python_highlight_all = 0

"Java"
autocmd FileType java let java_highlight_functions = 1
autocmd FileType java imap <buffer> sout<Tab> System.out.println();<Left><Left>
autocmd Filetype java imap <buffer> main<Tab> public static void main(String[] args) {}<Left><CR>

"Latex"
autocmd FileType tex imap <buffer> bullet<Tab> \begin{itemize}<CR>\item <CR><Backspace><Backspace>\end{itemize}<Up>


"Ruby"
let g:ruby_host_prog = '/usr/lib64/ruby/gems/2.5.0/gems/neovim-0.8.0/exe/neovim-ruby-host'

"Nerdtree"
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.class$', '__pycache__']
let g:NERDTreeQuitOnOpen = 1

"Coc.nvim"
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

"Airline"
let g:airline_theme = "ayu_mirage"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
