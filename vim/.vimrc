set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
set clipboard=unnamed

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

color desert

syntax on
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
    syntax on
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Numbers
set number
set numberwidth=5

" Dont use arrows in command mode 
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

"noremap <C-t> <Esc>:NERDTreeToggle<CR>"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Invoke CtrlP in normal mode "
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window_bottom = 1

" Working path is the parent directory of the current file "
let g:ctrlp_working_path_mode = 2

" Excluding version control directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*  " Linux/MacOSX

" The maximum depth of a directory tree to recurse into: "
let g:ctrlp_max_depth = 20

let g:ctrlp_extensions = ['funky']
nnoremap <Space>fu :CtrlPFunky<Cr>

" :w!! saves a file as root
cmap w!! w !sudo tee % >/dev/null

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'L9'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized' 
Bundle 'https://github.com/tpope/vim-fugitive' 
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'closetag.vim'
Bundle 'https://github.com/wincent/Command-T.git'
Bundle 'Solarized'
Bundle 'The-NERD-Commenter'
Bundle 'ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky'
Bundle 'Guardian'
Bundle 'EasyMotion'
Bundle 'Valloric/YouCompleteMe'
filetype plugin indent on
