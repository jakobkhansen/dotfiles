let mapleader="\<Space>"
let home=$HOME

"Plugins"
    call plug#begin()
        "Plugin dependencies"
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'RishabhRD/popfix'


        "Text manipulation"
        Plug 'scrooloose/nerdcommenter'
        Plug 'cohama/lexima.vim'

        "Movement"
        Plug 'easymotion/vim-easymotion'
        Plug 'psliwka/vim-smoothie'

        "Syntax highlighting"
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'sheerun/vim-polyglot'


        "Themes"
        Plug 'christianchiarulli/nvcode-color-schemes.vim'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'


        "Files and git"
        Plug '907th/vim-auto-save'
        Plug 'tpope/vim-fugitive'
        Plug 'kyazdani42/nvim-tree.lua'

        "Menus"
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'liuchengxu/vim-which-key'
        Plug 'mhinz/vim-startify'

        "LSP"
        Plug 'neovim/nvim-lspconfig'
        Plug 'RishabhRD/nvim-lsputils'
        Plug 'hrsh7th/nvim-compe'
        Plug 'mfussenegger/nvim-jdtls'
        Plug 'glepnir/lspsaga.nvim'

        "Snippets"
        Plug 'norcalli/snippets.nvim'

        "Notes"
        Plug 'reedes/vim-pencil'
        Plug 'instant-markdown/vim-instant-markdown'
        Plug 'lervag/vimtex'

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
    set mouse=a
    set scrolloff=10
    set number

"Lua wrappers"
command! LspDefinition lua vim.lsp.buf.definition()
command! LspImplementation lua vim.lsp.buf.implementation()
command! LspReferences lua vim.lsp.buf.references()
command! LspRenameSaga lua require('lspsaga.rename').rename()
command! LspCodeActionSaga Lspsaga code_action
command! LspFormat lua vim.lsp.buf.formatting_sync(nil, 100)
command! LspLineDiagnostics lua require'lspsaga.diagnostic'.show_line_diagnostics()

"Leader maps and which-key"
    nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
    let g:which_key_map = {}

    "Not categorized"
    noremap<Leader>no <CMD>nohlsearch<CR>

    "Find x"
    map <Leader>ff <CMD>Telescope find_files prompt_prefix=🔍<CR>
    map <Leader>fh <CMD>Telescope find_files find_command=rg,--files,/home/jakob prompt_prefix=🔍<CR>
    map <Leader>fz <CMD>Telescope find_files find_command=rg,--hidden,--files prompt_prefix=🔍<CR>
    map <Leader>fg <CMD>Telescope git_files prompt_prefix=🔍<CR>
    map <Leader>fc <CMD>Telescope live_grep prompt_prefix=🔍<CR>
    map <Leader>ft <CMD>Telescope builtin prompt_prefix=🔍<CR>

    let g:which_key_map.f = {
    \ 'name' : '+find',
    \ 'f' : [':Telescope find_files', 'find-files'],
    \ 'h' : [':Telescope find_files', 'find-files-home'],
    \ 'z' : [':Telescope find_files', 'find-hidden-files'],
    \ 'c' : [':Telescope live_grep', 'find-code'],
    \ 'g' : [':Telescope git_files', 'find-git-files'],
    \ 't' : [':Telescope builtin', 'find-telescope-builtin'],
    \}

    "LSP"
    map <silent> <Leader>ls <CMD>Lspsaga hover_doc<CR>
    map <silent> <Leader>ld <CMD>LspDefinition<CR>
    map <silent> <Leader>li <CMD>LspImplementation<CR>
    map <silent> <Leader>lr <CMD>LspReferences<CR>
    map <silent> <Leader>ln <CMD>LspRenameSaga<CR>
    map <silent> <Leader>la <CMD>LspCodeActionSaga<CR>
    au FileType java noremap <silent> <buffer> <Leader>la <CMD>lua require('jdtls').code_action()<CR>
    map <silent> <Leader>lf <C-w>gf
    nmap <silent> <Leader>lp <CMD>LspFormat<CR>
    map <silent> <Leader>le <CMD>LspLineDiagnostics<CR>

    let g:which_key_map.l = {
    \ 'name' : '+lsp',
    \ 's' : [':Lspsaga hover_doc', 'show-documentation'],
    \ 'd' : [':LspDefinition', 'goto-definition'],
    \ 't' : [':LspDefinition', 'goto-type-defintion'],
    \ 'i' : [':LspImplementation', 'goto-implementation'],
    \ 'r' : [':LspReferences', 'goto-references'],
    \ 'n' : [':LspRenameSaga', 'rename-symbol'],
    \ 'a' : [':LspCodeActionSaga', 'code-action'],
    \ 'f' : ['<C-w>gf', 'goto-file'],
    \ 'p' : [':LspFormat', 'prettier-format'],
    \ 'e' : [':LspLineDiagnostics', 'line-diagnostics'],
    \ }

    "Terminal"
    map <silent> <Leader>tt <CMD>15split<bar>terminal<CR>
    map <silent> <Leader>tv <CMD>vsplit<bar>terminal<CR>
    map <silent> <Leader>ta <CMD>terminal<CR>

    let g:which_key_map.t = {
    \ 'name' : '+terminal',
    \ 't' : [':15split|terminal', 'mini-terminal'],
    \ 'v' : [':vsplit|terminal', 'vertical-terminal'],
    \ 'a' : [':tab terminal', 'tab-terminal'],
    \ }

    "Buffers and cwd"
    map <Leader>be <CMD>enew<CR>
    map <Leader>bd <CMD>bd<CR>
    map <Leader>BD <CMD>bn <bar> :bd#<CR>
    map <Leader>bc <CMD>cd %:p:h<CR>
    map <Leader>bv <CMD>vsplit<CR>
    map <Leader>bh <CMD>hsplit<CR>

    let g:which_key_map.b = {
    \ 'name' : '+buffer' ,
    \ 'd' : [':bd', 'close-file'],
    \ 'D' : [':bn|:bd#', 'delete-buffer'],
    \ 'v' : [':vsplit', 'vertical-split'],
    \ 'h' : [':split', 'horizontal-split'],
    \ 'e' : [':enew', 'open-empty-buffer'],
    \ 'c' : [':cd %:p:h', 'set-cwd'],
    \ }


    "Git"
    map <Leader>gc <CMD>Telescope git_commits prompt_prefix=🔍<CR>
    map <Leader>gb <CMD>Telescope git_branches prompt_prefix=🔍<CR>
    map <Leader>gh <CMD>Git blame<CR>
    map <Leader>gd <CMD>Git diff<CR>
    map <Leader>gm <CMD>Git mergetool<CR>

    let g:which_key_map.g = {
    \ 'name' : '+git',
    \ 'c' : [':Telescope git_commits', 'git-commits'],
    \ 'b' : [':Telescope git_branches', 'git-branch'],
    \ 'h' : [':Git blame', 'git-blame'],
    \ 'd' : [':Git diff', 'git-diff'],
    \ 'm' : [':Git mergetool', 'git-mergetool'],
    \}

    "Edit configuration files"
    map <silent> <Leader>cv <CMD>edit $MYVIMRC<CR>
    map <silent> <Leader>cb <CMD>edit $HOME/.bashrc<CR>
    map <silent> <Leader>cz <CMD>edit $HOME/.config/zsh/.zshrc<CR>
    map <silent> <Leader>ci <CMD>edit $HOME/.config/i3/config<CR>
    map <silent> <Leader>cr <CMD>edit $HOME/.config/ranger/rc.conf<CR>
    map <silent> <Leader>ck <CMD>edit $HOME/.config/kitty/kitty.conf<CR>
    map <silent> <Leader>cp <CMD>edit $HOME/.config/polybar/config<CR>
    map <silent> <Leader>ca <CMD>edit $HOME/.bash_aliases<CR>
    map <silent> <Leader>cc <CMD>edit $HOME/.config/nvim/coc-settings.json<CR>
    map <silent> <Leader>co <CMD>edit $HOME/.config/compton/compton.conf<CR>
    map <silent> <Leader>cs <CMD>source $MYVIMRC<CR>

    let g:which_key_map.c = {
    \ 'name': '+configs',
    \ 'v' : [':edit $MYVIMRC', 'config-vimrc'],
    \ 'b' : [':edit $HOME/.bashrc', 'config-bashrc'],
    \ 'a' : [':edit $HOME/.bash_aliases', 'config-aliases'],
    \ 'z' : [':edit $HOME/.config/zsh/.zshrc', 'config-zsh'],
    \ 'i' : [':edit $HOME/.config/i3/config', 'config-i3'],
    \ 'r' : [':edit $HOME/.config/ranger/rc.conf', 'config-ranger'],
    \ 'k' : [':edit $HOME/.config/kitty/kitty.conf', 'config-kitty'],
    \ 'p' : [':edit $HOME/.config/polybar/config', 'config-polybar'],
    \ 'c' : [':edit $HOME/.config/nvim/coc-settings.json', 'config-polybar'],
    \ 's' : [':source $MYVIMRC<CR>', 'config-reload-vim'],
    \}

    "Help"
    map <silent> <Leader>ht <CMD>Telescope help_tags prompt_prefix=🔍<CR>
    map <silent> <Leader>hm <CMD>Telescope man_pages prompt_prefix=🔍<CR>

    let g:which_key_map.h = {
    \ 'name': '+help',
    \ 't' : [':Telescope help_tags', 'help-tags'],
    \ 'm' : [':Telescope man_pages', 'man-pages'],
    \}

    let g:which_key_map.n = {'name' : 'which_key_ignore'}

    call which_key#register('<Space>', "g:which_key_map")


"Vim Bindings"
    "Remaps"
    nnoremap + $
    vnoremap + $
    nnoremap "" "+y
    vnoremap "" "+y
    map $ <Nop>
    map <F1> <Esc>
    map <LeftMouse> <Nop>
    imap <LeftMouse> <Nop>


    "Movement"
    nmap <silent> K 10k
    nmap <silent> J 10j
    vmap <silent> K 10k
    vmap <silent> J 10j

    "Text manipulation"
    nnoremap <silent> Q gqap

    "Move lines"
    nnoremap <A-k> :m-2<CR>==
    nnoremap <A-j> :m+<CR>==

    "Buffers"
    nmap <Tab> <CMD>bn<CR>
    nmap <S-Tab> <CMD>bp<CR>
    nnoremap <F5> :%bd<bar>e#<bar>bd#<CR>
    nnoremap <F6> :bufdo bwipeout<CR>
        
    noremap <C-h> <C-w>h
    noremap <C-j> <C-w>j
    noremap <C-k> <C-w>k
    noremap <C-l> <C-w>l


    "Terminal"
    tnoremap <silent> <Leader>bd <C-\><C-n><CMD>bd!<CR>
    tnoremap <silent> <F1> <C-\><C-n>

    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l

    "Tab and shift tab in terminal mode, might be cumbersome if tab is used in terminal"
    tnoremap <silent> <Leader><Tab> <C-\><C-N><CMD>bn<CR>
    tnoremap <silent> <Leader><S-Tab> <C-\><C-N><CMD>bp<CR>

    "Bypass warning when closing terminal
    au TermOpen * noremap <Leader>bd <CMD>bd!<CR>
    
    "Always start in insert mode in terminal"
    autocmd BufWinEnter,WinEnter term://* startinsert


"File management"
    "Persistent undo"
    let s:undoDir = "/tmp/.undodir_" . $USER
    if !isdirectory(s:undoDir)
        call mkdir(s:undoDir, "", 0700)
    endif
    let &undodir=s:undoDir
    set undofile

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
    let g:airline#extensions#tabline#ignore_bufadd_pat = '!|defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'



"Plugin configuration"
    "Easymotion"
    map s <plug>(easymotion-bd-f2)
    map S <plug>(easymotion-bd-f2)
    nmap s <Plug>(easymotion-overwin-f2)
    nmap S <Plug>(easymotion-overwin-f)
    let g:EasyMotion_smartcase = 1


    "Auto-save"
    let g:auto_save = 1
    let g:auto_save_silent = 1
    let g:auto_save_events = ["CursorHold", "InsertLeave", "TextChanged"]

    "Nerd commenter"
    noremap # :call NERDComment(0, "toggle")<CR>
    let g:NERDCreateDefaultMappings = 0

    "Nvim-tree"
    nnoremap <C-n> :NvimTreeToggle<CR>
    let g:nvim_tree_auto_close = 1
    let g:nvim_tree_ignore = [ '.class', '.pdf' ]
    let g:nvim_tree_quit_on_open = 1
    luafile $HOME/.config/nvim/lua/nvim-tree-config.lua

    "Telescope"
    luafile /home/jakob/.config/nvim/lua/telescope-config.lua

    "LSP"
    luafile $HOME/.config/nvim/lua/lsp-servers.lua
    luafile $HOME/.config/nvim/lua/lsp-config.lua
    luafile $HOME/.config/nvim/lua/lsputils-config.lua
    au FileType java lua start_jdt()

    "Lexima"
    let g:lexima_no_default_rules = v:true
    call lexima#set_default_rules()

    "Nvim-compe"
    set completeopt=menuone,noselect
    set pumheight=10
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <silent><expr> <CR> compe#confirm(lexima#expand('<LT>CR>', 'i'))
    
    let g:lexima_accept_pum_with_enter = 1
    luafile $HOME/.config/nvim/lua/nvim-compe-config.lua

    "Treesitter"
    luafile $HOME/.config/nvim/lua/treesitter-config.lua

    "Snippets.nvim"
    luafile $HOME/.config/nvim/lua/nvim-snippets-config.lua
    luafile $HOME/.config/nvim/lua/snips.lua

    "Latex"
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

    hi clear Conceal
