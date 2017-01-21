set nocompatible
set encoding=utf-8
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
set clipboard=unnamed

if $TERM == "xterm-256color" || $TERM == "tmux-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
  "set t_Co=16
endif

" gui colors if running iTerm
if $TERM_PROGRAM =~ "iTerm"
  set termguicolors
endif

set timeoutlen=1000 ttimeoutlen=0

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo

set undolevels=1000
set undoreload=10000

" Explore conflicts with plugins beginning with E, ambiguous command
command E Ex

syntax on
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
    syntax on
endif

" Softtabs, 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Make 100 character limit visible
set colorcolumn=100

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
set relativenumber
set numberwidth=4

" highlight current line
"set cursorline

" Dont use arrows in command mode 
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" airline
set laststatus=2
if has("gui_running")
  let g:airline_powerline_fonts = 1
else
  let g:airline_powerline_fonts = 0
endif

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Invoke CtrlP in normal mode "
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window_bottom = 1

map <c-b> :CtrlPBuffer<cr>

" Working path is the parent directory of the current file "
let g:ctrlp_working_path_mode = 'ra'

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
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

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
map \f :Ag 
map \u :buffer  
map \b :Gblame<cr>
map \w :w<cr>
map \\ :Neomake<cr>

" send selwction to tmux window C-c C-c
let g:slime_target = "tmux"

" use only jshint if no jscs file provided
"autocmd FileType javascript let b:syntastic_checkers = findfile('.jscsrc', '.;') != '' ? ['jscs', 'jshint'] : ['jshint']
" runs all checkers that apply to the current filetype
"let g:syntastic_aggregate_errors = 1
" setup Syntastic to automatically load errors into the location list
"let g:syntastic_always_populate_loc_list = 1
" By default, Syntastic does not check for errors when a file is loaded
"let g:syntastic_check_on_open = 0
" let g:syntastic_error_symbol = "✗"
" let g:syntastic_warning_symbol = "⚠"

let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }

let g:neomake_javascript_jscs_maker = {
    \ 'exe': 'jscs',
    \ 'args': ['--no-color', '--reporter', 'inline'],
    \ 'errorformat': '%f: line %l\, col %c\, %m',
    \ }

let g:neomake_javascript_enabled_makers = ['jscs', 'eslint']
" run neomake on each buffer save
autocmd! BufWritePost * Neomake

" speed up macros
set lazyredraw
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=128
set ttyfast " u got a fast terminal
" set ttyscroll=3

" map C-c to the line splitting command - useful in delimitMate
imap <C-c> <CR><Esc>O

" Run fixmyjs
noremap <Leader><Leader>f :Fixmyjs<CR>

" turn off default mapping of :JsDoc
let g:jsdoc_default_mapping=0

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'Vundle.vim'
Bundle 'L9'
"Bundle 'Syntastic'
Bundle 'https://github.com/tpope/vim-fugitive'
Bundle 'ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'surround.vim'
Bundle 'tpope/vim-rails'
Bundle 'thoughtbot/vim-rspec'
Bundle 'jgdavey/tslime.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'vim-ruby/vim-ruby'
Bundle 'ri-viewer'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'mattn/emmet-vim'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'pangloss/vim-javascript'
Bundle 'JavaScript-Indent'
Bundle 'claco/jasmine.vim'
Bundle 'marijnh/tern_for_vim'
Bundle 'jpalardy/vim-slime'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-unimpaired'
Bundle 'ruanyl/vim-fixmyjs'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'tpope/vim-sleuth'
Bundle 'tmux-plugins/vim-tmux-focus-events'
Bundle 'heavenshell/vim-jsdoc'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'tacahiroy/ctrlp-funky'
Bundle 'Valloric/YouCompleteMe'
Plugin 'chriskempson/base16-vim'
Plugin 'neomake/neomake'
Plugin 'editorconfig/editorconfig-vim'
Bundle 'mxw/vim-jsx'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'facebook/vim-flow'

" disable flowtype by default
let g:flow#enable = 0

" disable tern documentation view
autocmd BufEnter * set completeopt-=preview
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'

filetype plugin indent on

" To ensure that this plugin works well with Tim Pope's fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" enable jsx syntax highlighting for non jsx files
let g:jsx_ext_required = 0

colorscheme base16-materia
let g:airline_theme='base16'

let g:tmux_navigator_no_mappings = 1

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Tmux navigation
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
