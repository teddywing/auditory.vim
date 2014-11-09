" Get the script path so we can resolve the audio file paths
let s:script_path = resolve(expand('<sfile>:p:h')) . '/..'


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
" ==========

function! auditory#Play(file)
	call system("mplayer " . s:script_path . a:file . " &")
endfunction


" Insert mode
" ===========

" Old functions that would start a song when entering insert mode and stop the 
" song when leaving insert mode.
function! s:PlayInsertEnter()
	call auditory#Play("/private/test-track.mp3")
	let s:insert_mode_pid = s:GetPid()
endfunction

function! s:PlayInsertLeave()
	call s:KillPid(s:insert_mode_pid)
endfunction


function! auditory#PlayScale()
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
	
	call auditory#Play('/Resources/Scale_C#/' . scale[note])
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
	
	call auditory#Play('/Resources/Cantina/' . cantina[s:galaxy_far_far_away_index])
	
	let s:galaxy_far_far_away_index += 1

	if s:galaxy_far_far_away_index >= len(cantina)
		let s:galaxy_far_far_away_index = 0
	endif
endfunction


let s:galaxy_far_far_away = 0
function! auditory#ToggleGalaxyFarFarAway()
	if s:galaxy_far_far_away
		augroup auditory#insert_mode
			autocmd!
			autocmd CursorMovedI * call auditory#PlayScale()
		augroup END
		let s:galaxy_far_far_away = 0
	else
		augroup auditory#insert_mode
			autocmd!
			autocmd CursorMovedI * call <SID>GalaxyFarFarAway()
		augroup END
		let s:galaxy_far_far_away = 1
	endif
endfunction


" Normal mode
" ===========

function! auditory#NormalModeMappings()
	nnoremap <silent> h :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'h'<cr>
	nnoremap <silent> j :<c-u>call auditory#Play('/Resources/Normal_Mode/Down.wav') \| exec 'normal!' v:count1 . 'j'<cr>
	nnoremap <silent> k :<c-u>call auditory#Play('/Resources/Normal_Mode/Up.wav') \| exec 'normal!' v:count1 . 'k'<cr>
	nnoremap <silent> l :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'l'<cr>
	
	nnoremap <silent> gj :<c-u>call auditory#Play('/Resources/Normal_Mode/Down.wav') \| exec 'normal!' v:count1 . 'gj'<cr>
	nnoremap <silent> gk :<c-u>call auditory#Play('/Resources/Normal_Mode/Up.wav') \| exec 'normal!' v:count1 . 'gk'<cr>
	
	" nnoremap <silent> <space> :<c-u>call auditory#Play('/Resources/Normal_Mode/Down.wav') \| exec 'normal!' v:count1 . '<space>'<cr>
	" nnoremap <silent> <bs> :<c-u>call auditory#Play('/Resources/Normal_Mode/Up.wav') \| exec 'normal!' v:count1 . '<bs>'<cr>
	
	nnoremap <silent> 0 :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '0'<cr>
	nnoremap <silent> ^ :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '^'<cr>
	nnoremap <silent> _ :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . '_'<cr>
	nnoremap <silent> $ :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . '$'<cr>
	nnoremap <silent> g_ :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'g_'<cr>
	nnoremap <silent> % :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>%
	
	nnoremap <silent> b :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'b'<cr>
	nnoremap <silent> w :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'w'<cr>
	nnoremap <silent> e :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'e'<cr>
	nnoremap <silent> B :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav') \| exec 'normal!' v:count1 . 'B'<cr>
	nnoremap <silent> W :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'W'<cr>
	nnoremap <silent> E :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . 'E'<cr>
	
	nnoremap <silent> p :<c-u>call auditory#Play('/Resources/Normal_Mode/Paste.wav') \| exec 'normal!' v:count1 . 'p'<cr>
	nnoremap <silent> P :<c-u>call auditory#Play('/Resources/Normal_Mode/Paste.wav') \| exec 'normal!' v:count1 . 'P'<cr>
	
	nnoremap / :<c-u>call auditory#Play('/Resources/Normal_Mode/Search.wav')<cr>/
	nnoremap n :<c-u>call auditory#Play('/Resources/Normal_Mode/Search.wav')<cr>n
	nnoremap N :<c-u>call auditory#Play('/Resources/Normal_Mode/Search.wav')<cr>N
	nnoremap # :<c-u>call auditory#Play('/Resources/Normal_Mode/Search.wav')<cr>#
	nnoremap * :<c-u>call auditory#Play('/Resources/Normal_Mode/Search.wav')<cr>*
	
	nnoremap <silent> zt :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>zt
	nnoremap <silent> z. :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>z.
	nnoremap <silent> zz :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>zz
	nnoremap <silent> zb :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>zb
	" nnoremap <silent> <c-d> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-d>'<cr>
	" nnoremap <silent> <c-u> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-u>'<cr>
	" nnoremap <silent> <c-f> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-f>cr>
	" nnoremap <silent> <c-b> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-b>'<cr>
	
	nnoremap <silent> ( :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '('<cr>
	nnoremap <silent> ) :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . ')'<cr>
	nnoremap <silent> { :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '{'<cr>
	nnoremap <silent> } :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '}'<cr>
	
	nnoremap <silent> <c-i> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-i>'<cr>
	nnoremap <silent> <c-o> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . '<c-o>'<cr>
	
	nnoremap <silent> gg :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count1 . 'gg'<cr>
	nnoremap <silent> G :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav') \| exec 'normal!' v:count . 'G'<cr>
	
	nnoremap <silent> x :<c-u>call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . 'x'<cr>
	vnoremap <silent> x :<c-u>call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . 'x'<cr>
	" nnoremap <silent> d :<c-u>call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . 'd'<cr>
	" nnoremap <silent> d :<c-u>set opfunc=d \| call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . @g<cr>
	
	" inoremap <silent> <c-p> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-p><c-p>
	" inoremap <silent> <c-n> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-n><c-n>
endfunction
