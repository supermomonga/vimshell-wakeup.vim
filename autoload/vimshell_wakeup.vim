let s:save_cpo = &cpo
set cpo&vim


" Default settings
let g:vimshell_wakeup_shaberu_force_turnon        = get(g:, 'vimshell_wakeup_shaberu_force_turnup', 0)
let g:vimshell_wakeup_shaberu_text                = get(g:, 'vimshell_wakeup_shaberu_text', '処理が終了しました')
let g:vimshell_wakeup_threshold                   = get(g:, 'vimshell_wakeup_threshold', 5)
let g:vimshell_wakeup_vim_active                  = 1
let g:vimshell_wakeup_last_command_started        = localtime()
let g:vimshell_wakeup_last_command_finished       = localtime()
let g:vimshell_wakeup_last_command_execution_time = g:vimshell_wakeup_last_command_finished - g:vimshell_wakeup_last_command_started


" Autocmd to detect wether vim is active or.
augroup plugin-vimshell_wakeup
  autocmd!
augroup END

autocmd plugin-vimshell_wakeup FocusGained * let g:vimshell_wakeup_vim_active=1
autocmd plugin-vimshell_wakeup FocusLost * let g:vimshell_wakeup_vim_active=0



function! vimshell_wakeup#preexec(cmdline, context)
  let g:vimshell_wakeup_last_command_started = localtime()
  return a:cmdline
endfunction

function! vimshell_wakeup#postexec(cmdline, context)
  let g:vimshell_wakeup_last_command_finished = localtime()
  let g:vimshell_wakeup_last_command_execution_time = g:vimshell_wakeup_last_command_finished - g:vimshell_wakeup_last_command_started
  call vimshell_wakeup#notif()
  return a:cmdline
endfunction

function! vimshell_wakeup#notif()
  " Shaberanai if command finished in short time.
  if g:vimshell_wakeup_last_command_execution_time < g:vimshell_wakeup_threshold
    " call shaberu#say('hello')
    return
  endif
  " Shaberanai if Vim is active and current buffer is vimshell.
  if g:vimshell_wakeup_vim_active == 1 && &filetype == 'vimshell'
    " call shaberu#say('hi')
    return
  endif
  " Shaberu.
  let l:shaberu_original_mute_state = g:shaberu_is_mute
  if g:vimshell_wakeup_shaberu_force_turnon == 1
    let g:shaberu_is_mute = 0
  endif
  call shaberu#say(g:vimshell_wakeup_shaberu_text)
  let g:shaberu_is_mute = l:shaberu_original_mute_state
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
