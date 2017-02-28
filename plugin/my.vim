
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
