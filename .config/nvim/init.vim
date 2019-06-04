call plug#begin()

"Syntax"
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'

"Visual"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ananagame/vimsence'
Plug 'romainl/flattened'
Plug 'ayu-theme/ayu-vim'


"Files"
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

"Languages / intellisense"
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

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

"Lines and navigation"
set number
set hidden
set smartcase
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
nmap <LeftMouse> <nop>
imap <LeftMouse> <nop>
vmap <LeftMouse> <nop>
nnoremap <silent> <C-U> 10k
nnoremap <silent> <C-D> 10j
nnoremap <A-k> :m-2<CR>==
nnoremap <A-j> :m+<CR>==
noremap # :call NERDComment(0, "toggle")<CR>
nnoremap  <silent>   <tab> :bn<CR> 
nnoremap  <silent> <s-tab> :bp<CR>

"Splits"
set splitbelow
set splitright
:command SplitTerminal 10sp | terminal
:tnoremap <Esc> <C-\><C-n>

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
colorscheme flattened_dark
set fcs=eob:\ 
hi Normal guibg=NONE ctermbg=NONE

"Java"
let java_highlight_functions = 1
imap sout<Tab> System.out.println();<Left><Left>
imap main<Tab> public static void main(String[] args) {}<Left><CR>

"Nerdtree"
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.class$']

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