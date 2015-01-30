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

" Add spell checking for commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" Display extra whitespace
set list listchars=tab:»·,trail:·

set showmatch " Highlight matching braces/parents/brackets
set incsearch " find as you type search
set ignorecase " case insensitive search
set smartcase " case sensitive when uppercase letters present
set wildmenu " show shell style completion list

" sets 'path' to:
" " - the directory of the current file
" " - every subdirectory of the current directory
set path=.,**

" Numbers
set number
set numberwidth=4

" highlight current line
set cursorline

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

" Ex commands leader key shortcuts
map \g :Gstatus<cr>
map \e :Explore<cr>
map \s :Sexplore<cr>
map \v :Vexplore<cr>
map \f :find 

" send selwction to tmux window C-c C-c
let g:slime_target = "tmux"

" setup Syntastic to automatically load errors into the location list
let g:syntastic_always_populate_loc_list = 1
" By default, Syntastic does not check for errors when a file is loaded
let g:syntastic_check_on_open = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

" speed up macros
set lazyredraw
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=512
set ttyfast " u got a fast terminal
set ttyscroll=3

" map C-c to the line splitting command - useful in delimitMate
imap <C-c> <CR><Esc>O

" Run fixmyjs
noremap <Leader><Leader>f :Fixmyjs<CR>

autocmd FileType javascript noremap <buffer>  <c-b> :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-b> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-b> :call CSSBeautify()<cr>
" for visual mode
autocmd FileType javascript vnoremap <buffer>  <c-b> :call RangeJsBeautify()<cr>
autocmd FileType html vnoremap <buffer> <c-b> :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <c-b> :call RangeCSSBeautify()<cr>

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
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'JavaScript-Indent'
Bundle 'claco/jasmine.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'marijnh/tern_for_vim'
Bundle 'jpalardy/vim-slime'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-unimpaired'
Bundle 'ruanyl/vim-fixmyjs'
Bundle 'maksimr/vim-jsbeautify'

" disable tern documentation view
autocmd BufEnter * set completeopt-=preview
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

filetype plugin indent on

highlight SignColumn ctermbg=black
