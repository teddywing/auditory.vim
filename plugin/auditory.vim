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


let s:galaxy_far_far_away_index = 0
function! s:GalaxyFarFarAway()
	let cantina = [
		\ 'Cantina_1.1.wav',
		\ 'Cantina_1.2.wav',
		\ 'Cantina_1.3.wav',
		\ 'Cantina_1.4.wav',
		\ 'Cantina_2.1.wav',
		\ 'Cantina_2.2.wav',
		\ 'Cantina_2.3.wav',
		\ 'Cantina_2.4.wav',
		\ 'Cantina_3.1.wav',
		\ 'Cantina_3.2.wav',
		\ 'Cantina_3.3.wav',
		\ 'Cantina_3.4.wav',
		\ 'Cantina_4.1.wav',
		\ 'Cantina_4.2.wav',
		\ 'Cantina_4.3.wav',
		\ 'Cantina_4.4.wav',
		\ 'Cantina_5.1.wav',
		\ 'Cantina_5.2.wav',
		\ 'Cantina_5.3.wav',
		\ 'Cantina_5.4.wav',
		\ 'Cantina_6.1.wav',
		\ 'Cantina_6.2.wav',
		\ 'Cantina_6.3.wav',
		\ 'Cantina_6.4.wav',
		\ 'Cantina_7.1.wav',
		\ 'Cantina_7.2.wav',
		\ 'Cantina_7.3.wav',
		\ 'Cantina_7.4.wav',
		\ 'Cantina_8.1.wav',
		\ 'Cantina_8.2.wav',
		\ 'Cantina_8.3.wav',
		\ 'Cantina_8.4.wav'
	\ ]
	
	call auditory#Play('./Resources/Cantina/' . cantina[s:galaxy_far_far_away_index])
	
	let s:galaxy_far_far_away_index += 1

	if s:galaxy_far_far_away_index >= len(cantina)
		let s:galaxy_far_far_away_index = 0
	endif
endfunction


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
	
	nnoremap <silent> p :<c-u>call auditory#Play('./Resources/Normal_Mode/Paste.wav') \| exec 'normal!' v:count1 . 'p'<cr>
	nnoremap <silent> P :<c-u>call auditory#Play('./Resources/Normal_Mode/Paste.wav') \| exec 'normal!' v:count1 . 'P'<cr>
	
	nnoremap / :<c-u>call auditory#Play('./Resources/Normal_Mode/Search.wav')<cr>/
	nnoremap n :<c-u>call auditory#Play('./Resources/Normal_Mode/Search.wav')<cr>n
	nnoremap N :<c-u>call auditory#Play('./Resources/Normal_Mode/Search.wav')<cr>N
	
	nnoremap <silent> zt :<c-u>call auditory#Play('./Resources/Normal_Mode/Jump.wav')<cr>zt
	nnoremap <silent> z. :<c-u>call auditory#Play('./Resources/Normal_Mode/Jump.wav')<cr>z.
	nnoremap <silent> zz :<c-u>call auditory#Play('./Resources/Normal_Mode/Jump.wav')<cr>zz
	nnoremap <silent> zb :<c-u>call auditory#Play('./Resources/Normal_Mode/Jump.wav')<cr>zb
endfunction

call s:NormalModeMappings()



augroup auditory#insert_mode
	autocmd!
	" autocmd InsertEnter * call s:PlayInsertEnter()
	" autocmd InsertLeave * call s:PlayInsertLeave()
	" autocmd CursorMovedI * call s:PlayScale()
	autocmd CursorMovedI * call <SID>GalaxyFarFarAway()
augroup END


nnoremap <leader>so :source %<cr>
