" Pid
" ===

" Get most recent mplayer pid
function! s:GetPid()
	return system("ps | grep mplayer | head -n1 | awk '{printf $1}'")
endfunction

" Run system kill
function! s:KillPid(pid)
	return system("kill " . a:pid)
endfunction

" Play audio
function! auditory#Play(file)
	call system("mplayer " . a:file . " &")
endfunction

" Insert mode functions
function! s:PlayInsertEnter()
	call auditory#Play("./private/test-track.mp3")
	let s:insert_mode_pid = s:GetPid()
endfunction

function! s:PlayInsertLeave()
	call s:KillPid(s:insert_mode_pid)
endfunction

function! s:PlayScale()
	let play_scale_previous_note = -1
	let note = -1
	let scale = [
		\ '1_C#.wav',
		\ '2_D#.wav',
		\ '3_E#.wav',
		\ '4_F#.wav',
		\ '5_G#.wav',
		\ '6_A#.wav',
		\ '7_B#.wav'
	\ ]
	
	while play_scale_previous_note ==# note
		let note = system("echo $RANDOM % " . len(scale) . " | bc")
	endwhile
	
	let play_scale_previous_note = note
	
	call auditory#Play('./Resources/Scale_C#/' . scale[note])
endfunction


" auditory#InsertGalaxyFarFarAway()


augroup auditory#insert_mode
	autocmd!
	" autocmd InsertEnter * call s:PlayInsertEnter()
	" autocmd InsertLeave * call s:PlayInsertLeave()
	autocmd CursorMovedI * call s:PlayScale()
augroup END


nnoremap <leader>so :source %<cr>
