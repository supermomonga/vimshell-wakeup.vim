" Notification of long task in vimshell
" Version: 0.0.1
" Author : supermomonga (@supermomonga)

if exists('g:loaded_vimshell_wakeup')
  finish
endif
let g:loaded_vimshell_wakeup = 1

let s:save_cpo = &cpo
set cpo&vim

" Add hooks to vimshell
autocmd FileType vimshell
      \  call vimshell#hook#add('preexec',  'vimshell_wakeup_preexec',  'vimshell_wakeup#preexec')
      \| call vimshell#hook#add('postexec', 'vimshell_wakeup_postexec', 'vimshell_wakeup#postexec')



let &cpo = s:save_cpo
unlet s:save_cpo
