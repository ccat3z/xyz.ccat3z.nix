"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __
" | |_) | | | | |/ _` | | '_ \
" |  __/| | |_| | (_| | | | | |
" |_|   |_|\__,_|\__, |_|_| |_|
"                |___/

if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

" display
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'jdevera/vim-cs-explorer'
" Plug 'Yggdroot/indentLine'
" Plug 'vim-scripts/restore_view.vim'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

" util
Plug 'asins/vimcdoc'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
if has('nvim')
    Plug 'lambdalisue/suda.vim'
else
    Plug 'chrisbra/SudoEdit.vim'
endif
Plug 'embear/vim-localvimrc'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'tyru/caw.vim'
Plug 'Shougo/context_filetype.vim'
Plug 'jamessan/vim-gnupg'

" coding
" auto
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'

" deoplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" linter
Plug 'w0rp/ale'

" language
" clang
Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] } " NOTE required clang

" fish
Plug 'dag/vim-fish', { 'for': 'fish' }

" go
" Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go' } " NOTE required gocode

" haskell
" Plug 'eagletmt/neco-ghc' " NOTE required ghc-mod
 
" json5
Plug 'GutenYe/json5.vim'

" latex
Plug 'lervag/vimtex'

" ledger
Plug 'ledger/vim-ledger'

" org-mode
Plug 'tpope/vim-speeddating'
Plug 'jceb/vim-orgmode'

" pandoc
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'pandoc.markdown' }

" python
Plug 'zchee/deoplete-jedi', { 'for': 'python' } " NOTE required python-jedi
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' } " NOTE required python-yapf
Plug 'davidhalter/jedi-vim', { 'for': 'python' } " NOTE required python-jedi
Plug 'vim-python/python-syntax', { 'for': 'python' }

" viml
Plug 'Shougo/neco-vim'

" vue
Plug 'posva/vim-vue', { 'for': 'vue' }

" nginx
Plug 'chr4/nginx.vim', { 'for': 'nginx' }

" nftables
Plug 'nfnty/vim-nftables'

call plug#end()

"   ____                                                         __ _
"  / ___|___  _ __ ___  _ __ ___   ___  _ __     ___ ___  _ __  / _(_) __ _
" | |   / _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \   / __/ _ \| '_ \| |_| |/ _` |
" | |__| (_) | | | | | | | | | | | (_) | | | | | (_| (_) | | | |  _| | (_| |
"  \____\___/|_| |_| |_|_| |_| |_|\___/|_| |_|  \___\___/|_| |_|_| |_|\__, |
"                                                                     |___/

filetype plugin on
filetype indent on
set ignorecase
set nocompatible

set background=dark

if !has('nvim')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

colorscheme base16-eighties
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set nowrap

syntax enable
syntax on

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set foldmethod=syntax
set nofoldenable

" set textwidth=80
set colorcolumn=81

set nobackup
set nowb
set noswapfile

set showcmd

set smartindent
set autoindent
set cindent

let mapleader=";"
let maplocalleader=";"

set guicursor=
set mouse=a

set updatetime=100

tnoremap <Esc> <C-\><C-n>

"  ____  _             _                          __ _
" |  _ \| |_   _  __ _(_)_ __     ___ ___  _ __  / _(_) __ _
" | |_) | | | | |/ _` | | '_ \   / __/ _ \| '_ \| |_| |/ _` |
" |  __/| | |_| | (_| | | | | | | (_| (_) | | | |  _| | (_| |
" |_|   |_|\__,_|\__, |_|_| |_|  \___\___/|_| |_|_| |_|\__, |
"                |___/                                 |___/

" Suda (nvim) / Sudo Edit (vim)
if has('nvim')
    command W :SudaWrite %
else
    command W :SudoWrite %
endif

" NERDTree
map <F4> :NERDTreeToggle<CR>
map <F5> :NERDTreeFocus<CR>
let NERDTreeShowLineNumbers=1
let NERDTreeWinSize=30
let NERDTreeWinPos="right"
" autocmd vimenter * if !argc() | NERDTree | endif

" UltiSnips
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"

" Localvimrc
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" indentLine
let g:indentLine_char = '┆'
let g:indentLine_enable = 1

" deoplete
let g:deoplete#enable_at_startup = 1
set completeopt+=noselect
" call deoplete#custom#option('omni_patterns', {
" \ 'ledger': ['[^:]*:.*'],
" \})

" jedi-vim
let g:jedi#completions_enabled = 0 " provide by deoplete-jedi
let g:jedi#goto_command = '<leader>d'
let g:jedi#goto_assignments_comman = '<leader>g'
let g:jedi#documentation_command = '<leader>do'
let g:jedi#rename_command = '<leader>r'
let g:jedi#usages_command = '<leader>u'
let g:jedi#use_splits_not_buffers = "top"

" python-syntax
let g:python_highlight_all = 1

" ale
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = {}
let g:ale_linters.c = ['clang'] " NOTE required clang
let g:ale_linters.python = ['flake8'] " NOTE required python-flake8
let g:ale_linters.latex = ['chktex']
let g:ale_linters.haskell = ['ghc']
let g:ale_linters.java = []
let g:ale_haskell_ghc_options = '-fno-code -v0 -dynamic'

" vimtex
let g:tex_flavor = 'plain'
" call deoplete#custom#var('omni', 'input_patterns', {
"     \ 'tex': g:vimtex#re#deoplete
"     \})
let g:vimtex_compiler_latexmk = {
    \ 'callback' : 0,
    \}
let g:vimtex_view_enabled = 0

" vim-pandoc
let g:pandoc#filetypes#handled = ["pandoc"]
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["c", "sql", "python", "verilog"]
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#spell#enabled = 0

" nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : ">",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "-",
    \ "Dirty"     : "x",
    \ "Clean"     : "o",
    \ 'Ignored'   : "",
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeShowIgnoredStatus = 0

" skywind3000/asyncrun.vim
let g:asyncrun_open = 8

" itchyny/lightline.vim
if !has('nvim')
    set laststatus=2
endif
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'git', 'filename', 'modified' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'readonly', 'fileformat', 'fileencoding', 'filetype', 'charvaluehex', 'winnr' ] ]
    \ }
let g:lightline.inactive = {
    \ 'left': [ [ 'filename', 'modified' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'filetype', 'winnr' ] ]
    \ }
let g:lightline.tabline = {
    \ 'left': [ [ 'tabs' ] ],
    \ 'right': [ [ 'close' ] ]
    \ }
let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
    \ }
" let g:lightline.component_function = {
"     \ 'git': 'GitState'
" 	\ }

function! GitState()
    let [added, modified, removed] = GitGutterGetHunkSummary()
    let l:state = FugitiveHead()
    for [flag, flagcount] in [
        \   ['+', added],
        \   ['-', removed],
        \   ['!', modified]
        \ ]
        if flagcount> 0
            let l:state .= printf(' %s%d', flag, flagcount)
        endif
    endfor
    if !empty(l:state)
        return ' ' . l:state
    else
        return ''
    endif
    return l:sy
endfunction

" tyru/caw.vim
map <C-_> <Plug>(caw:hatpos:toggle)

" gopass
" See: https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
