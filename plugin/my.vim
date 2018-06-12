if &cp || exists('g:myvim_loaded')
  finish
endif

let g:myvim_loaded = 1

set nocompatible     " not compatible with the old-fashion vi mode
set bs=2             " allow backspacing over everything in insert mode
set history=50       " keep 50 lines of command line history
set updatetime=100   " useful when update taglist
set ruler            " show the cursor position all the time
set autoread         " auto read when file is changed from outside
set hlsearch         " search highlighting
set incsearch        " incremental search
set smartcase        " when searching try to be smart about cases
set laststatus=2     " always show the statusline
set hid              " a buffer becomes hidden when it is abandoned
set number           " show the line number
"set so=7             " set 7 lines to the cursor - when moving vertically using j/k
set magic            " for regular expressions turn magic on
set showmatch        " Show matching brackets when text indicator is over them
set mat=2            " How many tenths of a second to blink when matching brackets

" default indent setttings, see http://vimcasts.org/episodes/tabs-and-spaces/
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set cindent
set smartindent

" tmp file
set nobackup
set nowritebackup
set noswapfile

" folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" wildmode
set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

" color
syntax on
color desert
set t_Co=256
set background=dark

" encoding
set fenc=cp936
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp936,big5,gb2312
set fileformats=unix,dos

" doubleword backspace
if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif

" paste mode switch
set pastetoggle=<F10>

" set leader to ,
let mapleader=","
let g:mapleader=","

" keymaps
nmap <leader>/ :nohl<CR>

" show-invisibles
"set listchars=tab:▸\ ,trail:·
nmap <leader>v :set list!<CR>: set cursorcolumn!<CR>

" reload vimrc
nmap <leader>rv :source $MYVIMRC<CR>

" Fast saving
nmap <leader>w :w!<cr>

nmap <leader>q :q<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
"command W w !sudo tee % > /dev/null

nmap <silent> <C-H> :tabprev<CR>
nmap <silent> <C-L> :tabnext<CR>
nmap <silent> <S-H> :wincmd h<CR>
nmap <silent> <S-L> :wincmd l<CR>
nmap <silent> - <PageUp>
nmap <silent> = <PageDown>

 " Remap VIM 0 to first non-blank character
map 0 ^

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
map <leader>tn :tabnew 

 " Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

 " Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" BUFREADPOST settings
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

"==============================================
autocmd BufWrite * :call TrimTabOrSpace()
func! TrimTabOrSpace()
  let fts = ['c', 'cpp', 'python']
  if index(fts, &filetype) != -1
    exe "normal mz"
    %s/\s\+$//ge
    %s/\t/    /ge
    exe "normal `z"
  endif
endfunc

"==============================================
autocmd BufNewFile *.h,*.hpp :call AddFileHeaderProtection()      
func AddFileHeaderProtection()
    let l:filename = substitute(expand("%"), "[\\./]", "_", "g")
    call setline(1, "#ifndef _" . toupper(l:filename))
    call setline(2, "#define _" . toupper(l:filename)) 
    call setline(3, "")
    call setline(4, "")
    call setline(5, "")
    call setline(6, "#endif")
    call AddAuthorInfomation()
endfunc

"==============================================
if !exists("g:my_head_company")
  let g:my_head_company= "chenshuangping"
endif
if !exists("g:my_head_author")
  let g:my_head_author= "mincore@163.com"
endif
autocmd BufNewFile *.c,*.cpp,*.cxx,*.cc :call AddAuthorInfomation()      
func AddAuthorInfomation()
    call append(0, "/* ===================================================")
    call append(1, " * Copyright (C) " . strftime("%Y") . " " . g:my_head_company . " All Right Reserved.")
    call append(2, " *      Author: " . g:my_head_author)
    call append(3, " *    Filename: " . expand("%"))
    call append(4, " *     Created: " . strftime("%Y-%m-%d %H:%M"))
    call append(5, " * Description: ")
    call append(6, " * ===================================================")
    call append(7, " */")
    call cursor(6, 17, 0)
endfunc
map <leader>aa :call AddAuthorInfomation()<CR>

"==============================================
autocmd BufRead *.ttcn3 call OnTtcnLoaded()
func OnTtcnLoaded()
  set filetype=ttcn
endfunc

"==============================================
func Make()
    let l:dir = "./"
    let l:count = 0
	while l:count < 8
        if file_readable(l:dir . "Makefile")
            exec 'make -C ' . l:dir
            break
        endif
        let l:dir = "../" . l:dir
        let l:count = l:count + 1
	endwhile
endfunc
nmap <leader>m :call Make()<CR>

"==============================================
set tags=$HOME/.tags/tags
