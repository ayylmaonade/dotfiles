" Sets the path nvim uses to load important vim settings
 set runtimepath+=/usr/share/vim/vimfiles

" Automatically jump to last position when re-opening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Set indentation to 8
set shiftwidth=4

" Shows the line number
set number
set relativenumber

" Enables spell-check
"set spell

" Highlights things when searching
set incsearch
set hlsearch

" Enable mouse
set mouse=a

" Enables syntax highlighting & indentation for most languages
:filetype plugin on
:filetype indent on
:syntax on
 
" Plugins
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" GitHub CoPilot
Plug 'github/copilot.vim'

" Using git URL
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Syntax highlighting for kitty.conf
Plug 'fladson/vim-kitty'

" Install _every_ colorscheme from vimawesome
Plug 'flazz/vim-colorschemes'

call plug#end()

" Loads colorscheme(s)
" colorscheme peachpuff
colorscheme gruvbox
