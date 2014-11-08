" Pid
" ===

" Get most recent mplayer pid
function! s:GetPid()
	return system("ps | grep mplayer | head -n1 | awk '{printf $1}'")
endfunction

" Run system kill
function! s:KillPid(pid)
	echom a:pid
	return system("kill " . a:pid)
endfunction

" Play audio
function! auditory#Play()
	call system("mplayer ./private/test-track.mp3 &")
endfunction

" Insert mode functions
function! s:PlayInsertEnter()
	call auditory#Play()
	let s:insert_mode_pid = s:GetPid()
endfunction

function! s:PlayInsertLeave()
	call s:KillPid(s:insert_mode_pid)
endfunction


nnoremap <silent> <leader>i :call auditory#Play()<cr>

nnoremap <leader>x :echo call s:GetPid()<cr>

augroup auditoryeinsert_mode
	autocmd!
	autocmd InsertEnter * call s:PlayInsertEnter()
	autocmd InsertLeave * call s:PlayInsertLeave()
augroup END


nnoremap <leader>so :source %<cr>
