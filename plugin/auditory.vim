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


" Normal mode
function! s:NormalModeMappings()
	nnoremap <silent> h :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'h'<cr>
	nnoremap <silent> j :<c-u>call auditory#Play('./Resources/Normal_Mode/Down.wav') \| exec 'normal!' v:count1 . 'j'<cr>
	nnoremap <silent> k :<c-u>call auditory#Play('./Resources/Normal_Mode/Up.wav') \| exec 'normal!' v:count1 . 'k'<cr>
	nnoremap <silent> l :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'l'<cr>
	
	nnoremap <silent> gj :<c-u>call auditory#Play('./Resources/Normal_Mode/Down.wav') \| exec 'normal!' v:count1 . 'gj'<cr>
	nnoremap <silent> gk :<c-u>call auditory#Play('./Resources/Normal_Mode/Up.wav') \| exec 'normal!' v:count1 . 'gk'<cr>
	
	nnoremap <silent> 0 :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '0'<cr>
	nnoremap <silent> ^ :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '^'<cr>
	nnoremap <silent> _ :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '_'<cr>
	nnoremap <silent> $ :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . '$'<cr>
	nnoremap <silent> g_ :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'g_'<cr>
	
	nnoremap <silent> b :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'b'<cr>
	nnoremap <silent> w :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'w'<cr>
	nnoremap <silent> e :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'e'<cr>
	nnoremap <silent> B :<c-u>call auditory#Play('./Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'B'<cr>
	nnoremap <silent> W :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'W'<cr>
	nnoremap <silent> E :<c-u>call auditory#Play('./Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'E'<cr>
endfunction

call s:NormalModeMappings()



augroup auditory#insert_mode
	autocmd!
	" autocmd InsertEnter * call s:PlayInsertEnter()
	" autocmd InsertLeave * call s:PlayInsertLeave()
	autocmd CursorMovedI * call s:PlayScale()
augroup END


nnoremap <leader>so :source %<cr>
