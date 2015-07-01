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

function! OpenMatchingFile()
    let l:filename=expand('%:r')
    let l:ext=expand('%:e')
    if l:ext == 'h'
        vsplit %:r.cpp
    elseif l:ext == 'cpp'
        vsplit %:r.h
    endif
endfunction
" }}}

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
filetype plugin indent on

set nocompatible
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
"default status line format is set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"lets replace %P (percentage) by %L (line count)
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %L
set laststatus=2            " always show the status line

if has("gui_running")
    set go+=rL
    " Maximize window on start up
    au GUIEnter * simalt ~x 
endif


" Tags
" default value for tags is "./tags,tags". We are appending ";" so that gvim
" looks for a tag file in the directory tree for the current file
" :echo tagfiles() will display all the tag files in use at any time
set tags=tags;
" }}}

" ***** Coloring changes {{{
"-------------------------------------------------------------------------------
colorscheme molokai
" set cc=81          " highlight column 81
" hi PMenuSel guibg=gray90 guifg=gray10
" hi Pmenu guibg=gray50
" hi PmenuThumb guifg=gray35
" hi ColorColumn guibg=grey21
hi IncSearch guifg=wheat guibg=peru
hi Search guibg=peru guifg=wheat
hi Todo guifg=orangered guibg=yellow2
" }}}


" ***** neocomplcache settings {{{
"-------------------------------------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" Recommended key-mappings. 
" <CR>: close popup and save indent. 
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>" 
" <TAB>: completion. 
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>" 
" }}}

" ***** CTRLP settings {{{
"-------------------------------------------------------------------------------
let g:ctrlp_extensions=['dir', 'bookmarkdir']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP $BASEDIR\xbox\base\input\ht'
let g:ctrlp_custom_ignore = {
    \ 'file': 'buildchk\.*\|buildfre\.*\|build\.*\|tags\|\.log$'
    \ }
" let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
let g:ctrlp_regexp = 1
let g:ctrlp_by_filename = 1
let g:ctrlp_tabpage_position = 'ac'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_relative = 1
" }}}

"
" ***** Commands {{{
"-------------------------------------------------------------------------------
command! -range Comment call Comment(<line1>,<line2>)
command! -range Uncomment call UnComment(<line1>,<line2>)
command! Sde call SdEdit(expand('%'))
command! Olo silent !start odd -lo %
command! Sdv silent !start sdv %
command! CopyFilename let @*=expand('%:p')
command! CopyFilepath let @*=expand('%:p:h')
command! UpdateLocalTags exe 'silent !start /MIN updateLocalTags.cmd ' . expand('%:p')
command! OpenMatch call OpenMatchingFile()
"command! OpenMatch echo expand('%')
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
    au BufWritePost *.c,*.cpp,*.h       UpdateLocalTags
augroup END
" }}}

" ***** Key Mappings {{{
"-------------------------------------------------------------------------------
map <F2> :Sde<CR>
map ,, "*
map <F4> :OpenMatch
" look into using <C-W>gf for the following
map <F5> :NERDTreeToggle<CR>
map <F10> :TagbarToggle<CR>

"<C-O> takes us to normal mode for one command
imap <F2> <C-O><F2>
imap <F3> <C-O><F3>
imap <C-V> <C-O>"+gp
imap <F10> <C-O>:TagbarToggle<CR>

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

noremap <C-H>  <C-W><C-H>
noremap <C-J>  <C-W><C-J>
noremap <C-K>  <C-W><C-K>
noremap <C-L>  <C-W><C-L>

imap <C-H>  <C-O><C-W><C-H>
imap <C-J>  <C-O><C-W><C-J>
imap <C-K>  <C-O><C-W><C-K>
imap <C-L>  <C-O><C-W><C-L>

" Move split buffers in the current tab
noremap <A-h> <C-W>H
noremap <A-j> <C-W>J
noremap <A-k> <C-W>K
noremap <A-l> <C-W>L
noremap <A-t> <C-W>T
noremap <A-=> <C-W>=

" Move accross tabs
map <C-Right> :tabn<CR>
map <C-Left> :tabp<CR>
map <C-Up> :tabfirst<CR>
map <C-Down> :tabl<CR>

imap <C-Right> <C-O><C-PageDown>
imap <C-Left> <C-O><C-PageUp>
imap <C-Up> <C-O>tabfirst<CR>
imap <C-Down> <C-O>tabl<CR>

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
