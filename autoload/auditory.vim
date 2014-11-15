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


let s:scale = [
	\ 'C#3.wav',
	\ 'C#4.wav',
	\ 'C#5.wav',
	\ 'D#3.wav',
	\ 'D#4.wav',
	\ 'D#5.wav',
	\ 'E#3.wav',
	\ 'E#4.wav',
	\ 'E#5.wav',
	\ 'F#3.wav',
	\ 'F#4.wav',
	\ 'F#5.wav',
	\ 'G#3.wav',
	\ 'G#4.wav',
	\ 'G#5.wav',
	\ 'A#3.wav',
	\ 'A#4.wav',
	\ 'A#5.wav',
	\ 'B#3.wav',
	\ 'B#4.wav',
	\ 'B#5.wav'
\ ]
function! auditory#PlayScale()
	let play_scale_previous_note = -1
	let note = -1
	
	while play_scale_previous_note ==# note
		let note = system("echo $RANDOM % " . len(s:scale) . " | bc")
	endwhile
	
	let play_scale_previous_note = note
	
	call auditory#Play('/Resources/Scale_C#/' . s:scale[note])
endfunction


let s:galaxy_far_far_away_index = 0
let s:cantina = [
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
	\ 'Cantina_8.4.wav',
	\ 'Cantina_9.1.wav',
	\ 'Cantina_9.2.wav',
	\ 'Cantina_9.3.wav',
	\ 'Cantina_9.4.wav',
	\ 'Cantina_10.1.wav',
	\ 'Cantina_10.2.wav',
	\ 'Cantina_10.3.wav',
	\ 'Cantina_10.4.wav',
	\ 'Cantina_11.1.wav',
	\ 'Cantina_11.2.wav',
	\ 'Cantina_11.3.wav',
	\ 'Cantina_11.4.wav',
	\ 'Cantina_12.1.wav',
	\ 'Cantina_12.2.wav',
	\ 'Cantina_12.3.wav',
	\ 'Cantina_12.4.wav',
	\ 'Cantina_13.1.wav',
	\ 'Cantina_13.2.wav',
	\ 'Cantina_13.3.wav',
	\ 'Cantina_13.4.wav',
	\ 'Cantina_14.1.wav',
	\ 'Cantina_14.2.wav',
	\ 'Cantina_14.3.wav',
	\ 'Cantina_14.4.wav',
	\ 'Cantina_15.1.wav',
	\ 'Cantina_15.2.wav',
	\ 'Cantina_15.3.wav',
	\ 'Cantina_15.4.wav',
	\ 'Cantina_16.1.wav',
	\ 'Cantina_16.2.wav',
	\ 'Cantina_16.3.wav',
	\ 'Cantina_16.4.wav'
\ ]
function! s:GalaxyFarFarAway()
	call auditory#Play('/Resources/Songs/Cantina/' . s:cantina[s:galaxy_far_far_away_index])
	
	let s:galaxy_far_far_away_index += 1

	if s:galaxy_far_far_away_index >= len(s:cantina)
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


" Operators
" =========
nnoremap <silent> d :set opfunc=<SID>Delete<CR>g@
nnoremap <silent> dd :set opfunc=<SID>DeleteLine<CR>g@$
vnoremap <silent> d :<C-U>call <SID>Delete(visualmode(), 1)<CR>

function! s:Delete(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"

	call auditory#Play('/Resources/Normal_Mode/Delete.wav')

	if a:0  " Invoked from Visual mode, use '< and '> marks.
		silent exe "normal! `<" . a:type . "`>d"
	elseif a:type == 'line'
		silent exe "normal! '[V']d"
	elseif a:type == 'block'
		silent exe "normal! `[\<C-V>`]d"
	else
		silent exe "normal! `[v`]d"
	endif

	let &selection = sel_save
endfunction

function! s:DeleteLine(type)
	call <SID>Delete('line')
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
	
	nnoremap <silent> <space> :<c-u>call auditory#Play('/Resources/Normal_Mode/Right.wav') \| exec 'normal!' v:count1 . '<space>'<cr>
	
	" FIXME: allow counts on the delete key
	nnoremap <silent> <bs> :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav')<cr><bs>
	
	nnoremap <silent> 0 :<c-u>call auditory#Play('/Resources/Normal_Mode/Left.wav')<cr>0
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
	
	" FIXME: Allow these scrolling commands to support counts. Was getting errors constructing them the other way
	nnoremap <silent> <c-d> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr><c-d>
	nnoremap <silent> <c-u> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr><c-u>
	nnoremap <silent> <c-f> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr><c-f>
	
	" FIXME: need to press <c-b> twice in order for it to work
	nnoremap <silent> <c-b> :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr><c-b>

	nnoremap <silent> H :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>H
	nnoremap <silent> M :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>M
	nnoremap <silent> L :<c-u>call auditory#Play('/Resources/Normal_Mode/Jump.wav')<cr>L
	
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
	
	nnoremap <silent> u :<c-u>call auditory#Play('/Resources/Normal_Mode/Undo.wav') \| exec 'normal!' v:count1 . 'u'<cr>
	
	" Note: redo doesn't currently support a count because the `v:count1` was giving me an error
	nnoremap <silent> <c-r> :<c-u>call auditory#Play('/Resources/Normal_Mode/Redo.wav')<cr><c-r>
endfunction
