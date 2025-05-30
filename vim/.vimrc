let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Sets the path nvim uses to load important vim settings
set runtimepath+=/usr/share/vim/vimfiles

" Automatically jump to last position when re-opening a file
if has("autocmd")
  au BufReadPost * if line("'\'") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Set indentation to 4 (or whatever you prefer)
set shiftwidth=4

" Shows the line number
set number
set relativenumber

" Shows the cursor position
"set cursorline

" Enables line wrapping & proper linebreaking
set wrap
set linebreak

" Enables spell-check
"set spell

" Highlights things when searching
set incsearch
set hlsearch

" Makes searching ignore capital(S)
set ignorecase

" Overrides ignorecase _only_ if searching for capitals
set smartcase

" Shows matching words when searching
set showmatch

" Enable mouse
set mouse=a

" Enables syntax highlighting & indentation for most languages
:filetype plugin on
:filetype indent on
:syntax on

" Displays shell, filename, total LOC & more on the status bar
set statusline =%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor
 
" Plugins
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } "TODO: Upgrade to telescope
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' } " outdated.

" GitHub Dashboard
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Syntax highlighting for kitty.conf
Plug 'fladson/vim-kitty'

" Scratchpads with lua (luapad)
Plug 'rafcamlet/nvim-luapad'

" Install _every_ colorscheme from vimawesome
Plug 'flazz/vim-colorschemes'

" Installs friendly-snippets
Plug 'rafamadriz/friendly-snippets'

" Code autocompletion using ultisnips & nvim-cmp 
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

call plug#end()

" Sources the lua file for nvim-cmp
if has('nvim')
    lua require('nvim-cmp')
endif

" Loads colorscheme(s)
" colorscheme peachpuff
colorscheme gruvbox
