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
        Plug 'erietz/vim-terminator'

        "Menus"
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'liuchengxu/vim-which-key'
        Plug 'mhinz/vim-startify'

        "LSP"
        Plug 'neovim/nvim-lspconfig'
        Plug 'RishabhRD/nvim-lsputils'
        Plug 'hrsh7th/nvim-compe'
        Plug 'mfussenegger/nvim-jdtls'

        "Snippets"
        Plug 'norcalli/snippets.nvim'

        "Notes"
        Plug 'reedes/vim-pencil'
        Plug 'instant-markdown/vim-instant-markdown'
        Plug 'lervag/vimtex'

        "Random"
        Plug 'hugolgst/vimsence'

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
    set timeoutlen=600
    set autochdir

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
    map <leader>ft <CMD>NvimTreeToggle<cr><bar><CMD>sleep 50m<CR><CMD>NvimTreeToggle<cr><bar><CMD>sleep 50m<CR><CMD>NvimTreeToggle<cr>
    
    let g:which_key_map.f = {
    \ 'name' : '+find',
    \ 'f' : [':Telescope find_files', 'find-files'],
    \ 'h' : [':Telescope find_files find_command=rg,--files,/home/jakob prompt_prefix=🔍', 'find-files-home'],
    \ 'z' : [':Telescope find_files find_command=rg,--hidden,--files prompt_prefix=🔍', 'find-hidden-files'],
    \ 'c' : [':Telescope live_grep', 'find-code'],
    \ 'g' : [':Telescope git_files', 'find-git-files'],
    \ 't' : ['NvimTreeToggle', 'file-tree'],
    \}

    "LSP"
    map <silent> <Leader>lh <CMD>LspHover<CR>
    map <silent> <Leader>ls <CMD>LspSignature<CR>
    map <silent> <Leader>ld <CMD>LspDefinition<CR>
    map <silent> <Leader>li <CMD>LspImplementation<CR>
    map <silent> <Leader>lr <CMD>LspReferences<CR>
    map <silent> <Leader>ln <CMD>LspRename<CR>
    nmap <silent> <Leader>la <CMD>LspCodeActionJava<CR>
    vmap <silent> <Leader>la <CMD>LspCodeActionJavaVisual<CR>
    map <silent> <Leader>lf <C-w>gf
    nmap <silent> <Leader>lp <CMD>LspFormat<CR>
    map <silent> <Leader>led <CMD>Telescope lsp_document_diagnostics<CR>
    map <silent> <Leader>lew <CMD>Telescope lsp_workspace_diagnostics<CR>
    map <silent> <Leader>lel <CMD>LspLineDiagnostics<CR>
    map <silent> <Leader>len <CMD>LspDiagnosticsNext<CR>
    map <silent> <Leader>lep <CMD>LspDiagnosticsPrev<CR>
    imap <silent> <A-Tab> <CMD>LspHover<CR>

    let g:which_key_map.l = {
    \ 'name' : '+lsp',
    \ 'h' : [':LspHover', 'show-hover'],
    \ 's' : [':LspSignature', 'show-signature'],
    \ 'd' : [':LspDefinition', 'goto-definition'],
    \ 'i' : [':LspImplementation', 'goto-implementation'],
    \ 'r' : [':LspReferences', 'goto-references'],
    \ 'n' : [':LspRename', 'rename-symbol'],
    \ 'a' : [':LspCodeAction', 'code-action'],
    \ 'f' : ['<C-w>gf', 'goto-file'],
    \ 'p' : [':LspFormat', 'prettier-format'],
    \ 'e' : {
        \ 'name' : '+diagnostics',
        \ 'l' : [':LspLineDiagnostics', 'line-diagnostics'],
        \ 'd' : ['Telescope lsp_document_diagnostics', 'document-diagnostics'],
        \ 'w' : ['Telescope lsp_workspace_diagnostics', 'workspace-diagnostics'],
        \ 'n' : [':LspDiagnosticsNext', 'next-diagnostic'],
        \ 'p' : [':LspDiagnosticsPrev', 'prev-diagnostic'],
        \ },
    \ }

    "Terminal"
    map <silent> <Leader>tt <CMD>15split<bar>terminal<CR>
    map <silent> <Leader>tv <CMD>vsplit<bar>terminal<CR>
    map <silent> <Leader>tf <CMD>terminal<CR>
    map <Leader>tr <CMD>TerminatorOpenTerminal<CR><CMD>TerminatorRunFileInTerminal<CR><Esc>


    let g:which_key_map.t = {
    \ 'name' : '+terminal',
    \ 't' : [':15split|terminal', 'mini-terminal'],
    \ 'v' : [':vsplit|terminal', 'vertical-terminal'],
    \ 'f' : [':terminal', ' full-terminal'],
    \ 'r' : [':TerminatorOpenTerminal<bar>TerminatorRunFileInTerminal', 'terminal-run'],
    \ }

    "Buffers and cwd"
    map <Leader>be <CMD>enew<CR>
    map <Leader>bd <CMD>bd!<CR>
    map <Leader>BD <CMD>bn <bar> :bd!#<CR>
    map <Leader>bc <CMD>cd %:p:h<CR>
    map <Leader>bv <CMD>vsplit<CR>
    map <Leader>bh <CMD>split<CR>

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
    map <Leader>gs <CMD>G<CR>

    let g:which_key_map.g = {
    \ 'name' : '+git',
    \ 'c' : [':Telescope git_commits', 'git-commits'],
    \ 'b' : [':Telescope git_branches', 'git-branch'],
    \ 'h' : [':Git blame', 'git-blame'],
    \ 'd' : [':Git diff', 'git-diff'],
    \ 'm' : [':Git mergetool', 'git-mergetool'],
    \ 's' : [':G', 'git-status'],
    \}

    "Help"
    map <silent> <Leader>ht <CMD>Telescope help_tags prompt_prefix=🔍<CR>
    map <silent> <Leader>hm <CMD>Telescope man_pages prompt_prefix=🔍<CR>
    map <silent> <Leader>hw <CMD>execute "h " . expand("<cword>")<CR>

    let g:which_key_map.h = {
    \ 'name': '+help',
    \ 't' : [':Telescope help_tags', 'help-tags'],
    \ 'm' : [':Telescope man_pages', 'man-pages'],
    \ 'w' : [':execute "h " . expand("<cword>")', 'help-cword'],
    \}

    "<Leader>no does :noh
    let g:which_key_map.n = {'name' : 'which_key_ignore'}

    "<Leader>BD does bd"
    let g:which_key_map.B = {'name' : 'which_key_ignore'}

    "<Leader>ss opens Startify"
    let g:which_key_map.s = {'name' : 'which_key_ignore'}

    call which_key#register('<Space>', "g:which_key_map")


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

    "Buffers"
    nmap <Tab> <CMD>bn<CR>
    nmap <S-Tab> <CMD>bp<CR>
    nnoremap <F5> :%bd!<bar>e#<bar>bd!#<CR>
    nnoremap <F6> :bufdo bwipeout!<CR>
        
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



    "Terminal"
    tnoremap <silent> <Esc> <C-\><C-n>

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
    map S <plug>(easymotion-bd-f2)
    map s <plug>(easymotion-bd-f2)
    nmap S <Plug>(easymotion-overwin-f2)
    nmap s <Plug>(easymotion-overwin-f)
    let g:EasyMotion_smartcase = 1

    "Auto-save"
    let g:auto_save = 1
    let g:auto_save_silent = 1
    let g:auto_save_events = ["CursorHold", "InsertLeave", "TextChanged"]

    "Nerd commenter"
    noremap # :call NERDComment(0, "toggle")<CR>
    let g:NERDCreateDefaultMappings = 0

    "Nvim-tree"
    let g:nvim_tree_auto_close = 1
    let g:nvim_tree_ignore = [ '.class', '.pdf' ]
    let g:nvim_tree_quit_on_open = 1
    let g:nvim_tree_hide_dotfiles = 1
    luafile $HOME/.config/nvim/lua/nvim-tree-config.lua

    "Telescope"
    luafile /home/jakob/.config/nvim/lua/telescope-config.lua
    "Telescope (or LSP?) randomly fucks with number and signcolumn
    au BufAdd,BufCreate,BufNew * set number
    au BufAdd,BufCreate,BufNew * set signcolumn=no

    "Ranger"
    let g:ranger_map_keys = 0

    "LSP"
    luafile $HOME/.config/nvim/lua/lsp-servers.lua
    luafile $HOME/.config/nvim/lua/lsp-config.lua
    luafile $HOME/.config/nvim/lua/lsputils-config.lua
    au FileType java lua start_jdt()

    "Lexima"
    "Return is 
    "let g:lexima_no_default_rules = v:true
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
            \ {'line': 'IN3050', 'cmd': 'cd $HOME/Documents/School/IN3050/'},
            \ {'line': 'IN3030', 'cmd': 'cd $HOME/Documents/School/IN3030/'},
            \ {'line': 'IN3020', 'cmd': 'cd $HOME/Documents/School/IN3020/'},
            \ {'line': 'Retting', 'cmd': 'cd $HOME/Documents/Retting/'},
        \]
        return files
    endfunction
    
    function! s:luaFiles()
        let files = systemlist('ls $HOME/.config/nvim/lua')
        return map(files, "{'line': v:val, 'path': '$HOME/.config/nvim/lua/'. v:val}")
    endfunction

    let g:startify_commands = [
        \ ['Reload Vim', 'source $MYVIMRC']
    \ ]

    "Terminator"
    command! RunTerminal <CMD>TerminatorOpenTerminal<CR><CMD>TerminatorRunFileInTerminal<CR>
    let g:terminator_clear_default_mappings = "foo bar"


    let g:startify_lists = [
    \ { 'type': 'files', 'header': ['MRU'] },
    \ { 'type': function('s:oftenUsed'), 'header': ['Often used'] },
    \ { 'type': function('s:configFiles'), 'header': ['Config files'], 'indices': ['cv', 'cb', 'ca', 'ci', 'cr', 'ck', 'cp', 'co'] },
    \ { 'type': 'commands', 'header': ['Commands'], 'indices': ['cs'] },
    \ { 'type': function('s:luaFiles'), 'header': ['Lua files'] },
    \ ]

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
    let g:instant_markdown_autostart = 0
    let g:instant_markdown_autoscroll = 1
    let g:instant_markdown_allow_unsafe_content = 1
    let g:instant_markdown_mathjax = 1
    let g:vim_markdown_math = 1


    augroup markdown
      au FileType markdown command! Preview call MarkdownPreview()
      au FileType markdown command! PreviewStop :InstantMarkdownStop
      au FileType markdown command! PreviewPDF call CompileMarkdownPDF()
      au FileType markdown call pencil#init({'wrap': 'soft', 'autoformat': 0})
      au FileType markdown command! -nargs=1 Img call MarkdownImage(<f-args>)
      au FileType markdown set conceallevel=2
    augroup END


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

    "Markdown conceal colors is weird because of Polyglot I guess"
    hi clear Conceal
