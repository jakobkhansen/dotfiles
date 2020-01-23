call plug#begin()

"Syntax"
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'

"Visual"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ananagame/vimsence'
Plug 'romainl/flattened'
Plug 'whatyouhide/vim-gotham'
Plug 'ayu-theme/ayu-vim'


"Files"
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

"Languages / intellisense"
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'lervag/vimtex'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

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

"Syntax"
set nocompatible     
syntax on
filetype on
filetype indent on
filetype plugin on
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"Lines and navigation"
set number
set hidden
set smartcase
set mouse=a
set tw=89
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
set fcs=eob:\ 
hi Normal guibg=NONE ctermbg=NONE

"Global hotkeys"
autocmd InsertLeave * write
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
nmap <F6> <Plug>(coc-rename)
nmap <F5> <Plug>(coc-definition)
nnoremap <buffer> * :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

"Java"
autocmd FileType java let java_highlight_functions = 1
autocmd FileType java imap <buffer> sout<Tab> System.out.println();<Left><Left>
autocmd Filetype java imap <buffer> main<Tab> public static void main(String[] args) {}<Left><CR>
"autocmd Filetype java nnoremap <buffer> * :CocCommand java.action.organizeImports<CR>

"Latex"

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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"Airline"
let g:airline_theme = "ayu_mirage"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
