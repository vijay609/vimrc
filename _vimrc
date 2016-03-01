" ***** Functions {{{
"-------------------------------------------------------------------------------
" Runs sd.exe from within vim
function! SdEdit(fileName)
    let autoreadbkp = &autoread
    let &autoread = 1
    let v:errmsg = ""
    checkt
    silent exe "!sd edit ".a:fileName." >NUL"
    let &autoread = autoreadbkp
    if v:errmsg == ""
        if &readonly "&& &modified
            set noreadonly
        end
        echohl "sd edit ".a:fileName
    else
        echohl a:fileName." not in source depot"
    end
endfunction

function! SdEditIfNecessary(fileName)
    if &readonly
        call SdEdit(a:fileName)
    end
endfunction

" Called when a file is changed both inside and outside vi
function! FCSHandler(name)
  let msg = 'File "'.a:name.'"'
  let v:fcs_choice = ''
  if v:fcs_reason == "deleted"
    let msg .= " has been deleted outside VIM."
    call setbufvar(expand(a:name), '&modified', '1')
    echohl WarningMsg
    echomsg msg
  elseif v:fcs_reason == "time"
    let msg .= " timestamp changed"
    echomsg msg
  elseif v:fcs_reason == "mode"
    let msg .= " permissions changed"
    echomsg msg
  elseif v:fcs_reason == "changed"
    let msg .= " contents changed"
    let v:fcs_choice = "ask"
  elseif v:fcs_reason == "conflict"
    echohl WarningMsg
    let msg .= " is modified, but was changed outside Vim. Reload File (Y/N)?"
    let response = input(msg,"N")
    if response == "Y"
        let v:fcs_choice ="reload"
    elseif response == "N"
        let v:fcs_choice = ""
    else
        let v:fcs_choice = "ask"
    endif
  else  " unknown values (future Vim versions?)
    let msg .= " FileChangedShell reason="
    let msg .= v:fcs_reason
    let v:fcs_choice = "ask"
    echohl ErrorMsg
    echomsg msg
endif
"  redraw!
  echohl None
endfunction

" ***** Settings {{{
"-------------------------------------------------------------------------------
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" ***** Settings For Vundle{{{
"-------------------------------------------------------------------------------
set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('$USERPROFILE\.vim\plugin')

" let Vundle manage Vundle, required
Plugin 'git://github.com/VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
Plugin 'git://github.com/tpope/vim-commentary.git'
Plugin 'git://github.com/Shougo/neocomplete.vim'
Plugin 'git://github.com/scrooloose/nerdtree.git'
Plugin 'git://github.com/bling/vim-airline'
Plugin 'git://github.com/kien/ctrlp.vim.git'
Plugin 'git://github.com/Raimondi/delimitMate.git'
Plugin 'git://github.com/altercation/vim-colors-solarized.git'
Plugin 'git://github.com/junegunn/vim-easy-align.git'
Plugin 'git://github.com/mileszs/ack.vim'
Plugin 'git://github.com/rking/ag.vim'
Plugin 'git://github.com/nathanaelkane/vim-indent-guides.git'
Plugin 'git://github.com/tpope/vim-surround.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" }}}

" ***** Settings For Vim Airline{{{
"-------------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" }}}


" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showcmd         " display incomplete commands
set incsearch       " do incremental searching
set whichwrap+=<,>,[,]
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

set ic                      " ignore case while searching 
set nobackup                " No backup
set nowritebackup
set noswapfile
set nu                      " turn on line numbering
set relativenumber          " relative line numbering
set hidden                  " don't need to save the buffer before switching
set autoindent              " turn on auto indentation
set expandtab               " No tabs, always spaces
set tabstop=4               " spaces per tab
set shiftwidth=4            " autoindent size
set list
set listchars=trail:.,tab:>> " show . for trailing spaces and >> for tabs
set history=100             " keep the last 100 commands around
set ruler                   " show the line and column number of the cursor position
set showmatch               " show matching brackets/braces/parantheses.
set visualbell              " vusual flash instead of a beep
set virtualedit=block       " :h virtualedit
set guioptions-=m           " Remove menubar from gui
set guioptions-=T           " Remove toolbar from gui
set guifont=courier_new:h10:

if has("gui_running")
    set go+=rL
    " Maximize window on start up
    au GUIEnter * simalt ~x 
endif
" }}}

" ***** Coloring changes {{{
"-------------------------------------------------------------------------------
syntax enable
set background=dark
colorscheme solarized
" }}}


" ***** neocomplcache settings {{{
"-------------------------------------------------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}


" ***** NerdTree settings {{{
let NERDTreeIgnore=['buildchk*[[file]]', 'buildfre*[[file]]', 'tags[[file]]']
"-------------------------------------------------------------------------------
" }}}

" ***** CTRLP settings {{{
"-------------------------------------------------------------------------------
let mapleader = " "
let g:ctrlp_cmd = 'CtrlPLastMode'
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'file': 'buildchk\.*\|buildfre\.*\|build\.*\|tags\|\.log$\|sd\.map\|sd\.ini\|sources.*\|dirs.*'
\}

let g:ctrlp_cache_dir = '$_NTDRIVE$_NTROOT\.cache\ctrlp'

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_root_markers = ['ObjectCapture']
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_switch_buffer = 'ETVH'

" Do not start in regex mode
let g:ctrlp_regexp = 0
" Use a leader instead of the actual named binding

nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>
" }}}

" ***** Settings For Silver Searcher{{{
"-------------------------------------------------------------------------------
" if executable ag is in path (google for silver searcher windows)
if executable('ag')
  " Use ag over grep
  set grepprg=Ag\ --nogroup\ --nocolor
  
  let g:ag_prg='Ag -S --vimgrep --nocolor --nogroup --column --ignore buildchk* --ignore buildfre* --ignore sd.* --ignore sources* --ignore dirs'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'Ag -l -g "" %s'
  let g:ag_working_path_mode='r'
  let g:ag_highlight=1

  " Map Ag to \
  nnoremap \ :Ag!<SPACE>
  " bind Ctrl-\ to grep word under cursor
  nmap <C-\> :Ag!<SPACE><C-R><C-W>
  
endif

" }}}


" ***** Delimtmate settings {{{
"-------------------------------------------------------------------------------
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1
" }}}

" ***** Vim Indent Guides settings {{{
"-------------------------------------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 3
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3

" }}}

"
" ***** Commands {{{
"-------------------------------------------------------------------------------
command! Sde call SdEdit(expand('%'))
command! Olo silent !start odd -lo %
command! Sdv silent !start sdv %
command! CopyFilename let @*=expand('%:p')
command! CopyFilepath let @*=expand('%:p:h')
" }}}

" ***** Auto Commands {{{
"-------------------------------------------------------------------------------
augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    " autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

augroup Special
    au!
    au FileChangedShell *               call FCSHandler(expand("<afile>:p"))
    au BufRead,BufNewFile *.man,        set ft=xml
    au BufEnter *                       silent! lcd %:p:h
    au FileChangedRO *                  call SdEditIfNecessary(expand("<afile>"))
augroup END
" }}}

" ***** Key Mappings {{{
"-------------------------------------------------------------------------------
map <F2> :Sde<CR>
map ,, "*
" look into using <C-W>gf for the following
map <F5> :NERDTreeToggle<CR>

"<C-O> takes us to normal mode for one command
imap <F2> <C-O><F2>
imap <F3> <C-O><F3>
imap <C-V> <C-O>"+gp

"Sick of capslock being on when I press H,J,K and L
map H h
map J j
map K k
map L l
map Q q

nmap <silent> <Space> :nohlsearch<CR>
nmap <Leader>b :ls<CR>:b<SPACE>
nmap <Leader>cd :lcd %:p:h<CR>
nmap <Leader>cfp :CopyFilepath
nmap <Leader>cfn :CopyFilename

noremap <A-h>  <C-W><C-H>
noremap <A-j>  <C-W><C-J>
noremap <A-k>  <C-W><C-K>
noremap <A-l>  <C-W><C-L>

" imap <C-H>  <C-O><C-W><C-H>
" imap <C-J>  <C-O><C-W><C-J>
" imap <C-K>  <C-O><C-W><C-K>
" imap <C-L>  <C-O><C-W><C-L>

" Move split buffers in the current tab
noremap <A-H> <C-W>H
noremap <A-J> <C-W>J
noremap <A-K> <C-W>K
noremap <A-L> <C-W>L
noremap <A-T> <C-W>T
noremap <A-=> <C-W>=

inoremap Oo <Esc>O
inoremap oO <Esc>O
" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" CTRL-Z is Undo; not in cmdline though
"inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" Remap Esc key in different modes
inoremap ii <Esc>
inoremap II <Esc>
inoremap iI <Esc>
inoremap Ii <Esc>
inoremap ;; <Esc>
cnoremap ;; <C-C>
noremap ;; <C-C>

"""""""""""""""""""""""""""""""""""Closer to windows""""""""""""""""""""""""
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V> "+gP
map <S-Insert> "+gP

cmap <C-V> <C-R>+
cmap <S-Insert> <C-R>+
" }}}

" ***** Abbreviations {{{
"-------------------------------------------------------------------------------
cabbrev olo Olo
cabbrev sdv Sdv
cabbrev sde Sde

cabbrev W w
cabbrev Q q

cabbrev wA wa
cabbrev WA wa
cabbrev Wa wa

cabbrev wQ wq
cabbrev WQ wq
cabbrev Wq wq
" }}}
