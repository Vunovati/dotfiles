set nocompatible
set encoding=utf-8
filetype off

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

" Add spell checking for commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" Display extra whitespace
" set list listchars=tab:»·,trail:·

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
" set laststatus=2
" let g:airline_powerline_fonts = 0

" Treat <li> and <p> tags like the block tags they are
" let g:html_indent_tags = 'li\|p'

" Invoke CtrlP in normal mode "
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window_bottom = 1

map <c-b> :CtrlPBuffer<cr>

" Working path is the parent directory of the current file "
let g:ctrlp_working_path_mode = 'ra'

syntax enable
"set background=dark

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Excluding version control directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*  " Linux/MacOSX

" The maximum depth of a directory tree to recurse into: "
let g:ctrlp_max_depth = 20

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$|\.class$\|\.jar$|\.war$|\.ear$|\.iml$|\.map$'
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

" Trusqoyomi used for typescript
autocmd FileType typescript nmap <buffer> <F6> <Plug>(TsuquyomiRenameSymbol)
autocmd FileType typescript nmap <buffer> <S-F6> <Plug>(TsuquyomiRenameSymbolC)
" let g:tsuquyomi_disable_default_mappings = 1

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

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

" toggle between dark and light background
nnoremap  <leader>B :<c-u>exe "colors" (g:colors_name =~# "dark"
    \ ? substitute(g:colors_name, 'dark', 'light', '')
    \ : substitute(g:colors_name, 'light', 'dark', '')
    \ )<cr>


" tune the contrast level
fun! Solarized8Contrast(delta)
  let l:schemes = map(["_low", "_flat", "", "_high"], '"solarized8_".(&background).v:val')
  exe "colors" l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endf

nmap <leader>- :<c-u>call Solarized8Contrast(-v:count1)<cr>
nmap <leader>+ :<c-u>call Solarized8Contrast(+v:count1)<cr>

let g:ale_sign_column_always = 1
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'typescript': ['tslint'],
      \   'json': ['jsonlint'],
      \}

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_fix_on_save = 0
let g:ale_javascript_prettier_options = '--single-quote --use-tabs --print-width 100'

set synmaxcol=128
set ttyfast " u got a fast terminal
" set ttyscroll=3

filetype plugin indent on

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:tmux_navigator_no_mappings = 1

colorscheme solarized8_dark

" allows cursor change in tmux mode
"if exists('$TMUX')
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif
"
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
