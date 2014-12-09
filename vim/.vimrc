set nocompatible
set encoding=utf-8
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
set clipboard=unnamed

if $TERM == "xterm-256color" || $TERM == "tmux-256color" || $COLORTERM == "gnome-terminal"
  "set t_Co=256
  set t_Co=16
endif

set background=dark
let g:solarized_termtrans = 1
color solarized

set timeoutlen=1000 ttimeoutlen=0

" Explore conflicts with plugins beginning with E, ambiguous command
command E Ex

" indent guides
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

syntax on
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
    syntax on
endif

" Softtabs, 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

set showmatch " Highlight matching braces/parents/brackets
set incsearch " find as you type search
set ignorecase " case insensitive search
set smartcase " case sensitive when uppercase letters present
set wildmenu " show shell style completion list

" Numbers
set number
set numberwidth=5

" Dont use arrows in command mode 
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

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

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$|\.class$\|\.jar$|\.war$|\.ear$|\.iml$'
  \ }

let g:ctrlp_extensions = ['funky']
nnoremap <Space>fu :CtrlPFunky<Cr>

let g:rspec_command = 'call Send_to_Tmux("rspec {spec}\n")'

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" :w!! saves a file as root
cmap w!! w !sudo tee % >/dev/null

" send selwction to tmux window C-c C-c
let g:slime_target = "tmux"

" speed up macros
set lazyredraw
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=128
set ttyfast " u got a fast terminal
set ttyscroll=3

" map C-c to the line splitting command - useful in delimitMate
imap <C-c> <CR><Esc>O

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'L9'
Bundle 'Syntastic'
Bundle 'altercation/vim-colors-solarized' 
Bundle 'https://github.com/tpope/vim-fugitive' 
Bundle 'Solarized'
Bundle 'ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'surround.vim'
Bundle 'tpope/vim-rails'
Bundle 'thoughtbot/vim-rspec'
Bundle 'jgdavey/tslime.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'vim-ruby/vim-ruby'
Bundle 'ri-viewer'
Bundle 'myusuf3/numbers.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'mattn/emmet-vim'
Bundle 'jelera/vim-javascript-syntax'
Bundle "pangloss/vim-javascript"
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'burnettk/vim-angular'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'JavaScript-Indent'
Bundle 'claco/jasmine.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'marijnh/tern_for_vim'
Bundle 'jpalardy/vim-slime'
Bundle 'Raimondi/delimitMate'

" disable tern documentation view
autocmd BufEnter * set completeopt-=preview

filetype plugin indent on

