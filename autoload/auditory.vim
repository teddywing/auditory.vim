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


" Standard Mappings
" =================

let s:mappings = {}
let s:mappings['h'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'h'<cr>",
\ }
let s:mappings['j'] = {
	\ 'audio': '/Resources/Normal_Mode/Down.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'j'<cr>",
\ }
let s:mappings['k'] = {
	\ 'audio': '/Resources/Normal_Mode/Up.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'k'<cr>",
\ }
let s:mappings['l'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'l'<cr>",
\ }

let s:mappings['gj'] = {
	\ 'audio': '/Resources/Normal_Mode/Down.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'gj'<cr>",
\ }
let s:mappings['gk'] = {
	\ 'audio': '/Resources/Normal_Mode/Up.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'gk'<cr>",
\ }

let s:mappings['<space>'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '<space>'<cr>",
\ }

" FIXME: allow counts on the delete key
let s:mappings['<bs>'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "<bs>",
\ }

let s:mappings['0'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "0",
\ }
let s:mappings['^'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '^'<cr>",
\ }
let s:mappings['_'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '_'<cr>",
\ }
let s:mappings['$'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '$'<cr>",
\ }
let s:mappings['g_'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'g_'<cr>",
\ }
let s:mappings['%'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "%",
\ }

let s:mappings['b'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'b'<cr>",
\ }
let s:mappings['w'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'w'<cr>",
\ }
let s:mappings['e'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'e'<cr>",
\ }
let s:mappings['B'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'B'<cr>",
\ }
let s:mappings['W'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'W'<cr>",
\ }
let s:mappings['E'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'E'<cr>",
\ }

let s:mappings['p'] = {
	\ 'audio': '/Resources/Normal_Mode/Paste.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'p'<cr>",
\ }
let s:mappings['P'] = {
	\ 'audio': '/Resources/Normal_Mode/Paste.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'P'<cr>",
\ }

let s:mappings['/'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
	\ 'map_to': "/",
\ }
let s:mappings['n'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
	\ 'map_to': "n",
\ }
let s:mappings['N'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
	\ 'map_to': "N",
\ }
let s:mappings['#'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
	\ 'map_to': "#",
\ }
let s:mappings['*'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
	\ 'map_to': "*",
\ }

let s:mappings['zt'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "zt",
\ }
let s:mappings['z.'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "z.",
\ }
let s:mappings['zz'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "zz",
\ }
let s:mappings['zb'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "zb",
\ }

" FIXME: Allow these scrolling commands to support counts. Was getting errors constructing them the other way
let s:mappings['<c-d>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "<c-d>",
\ }
let s:mappings['<c-u>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "<c-u>",
\ }
let s:mappings['<c-f>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "<c-f>",
\ }

" FIXME: need to press <c-b> twice in order for it to work
let s:mappings['<c-b>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "<c-b>",
\ }

let s:mappings['H'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "H",
\ }
let s:mappings['M'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "M",
\ }
let s:mappings['L'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "L",
\ }

let s:mappings['('] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '('<cr>",
\ }
let s:mappings[')'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . ')'<cr>",
\ }
let s:mappings['{'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '{'<cr>",
\ }
let s:mappings['}'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '}'<cr>",
\ }

let s:mappings['<c-i>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '<c-i>'<cr>",
\ }
let s:mappings['<c-o>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . '<c-o>'<cr>",
\ }

let s:mappings['gg'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'gg'<cr>",
\ }
let s:mappings['G'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'map_to': "exec 'normal!' v:count . 'G'<cr>",
\ }

let s:mappings['x'] = {
	\ 'audio': '/Resources/Normal_Mode/Delete.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'x'<cr>",
\ }
let s:mappings['v_x'] = {
	\ 'audio': '/Resources/Normal_Mode/Delete.wav',
	\ 'map_command': 'vnoremap',
	\ 'map_from': 'x',
	\ 'map_to': "exec 'normal!' v:count1 . 'x'<cr>",
\ }
" nnoremap <silent> d :<c-u>call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . 'd'<cr>
" nnoremap <silent> d :<c-u>set opfunc=d \| call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . @g<cr>

" inoremap <silent> <c-p> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-p><c-p>
" inoremap <silent> <c-n> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-n><c-n>

let s:mappings['u'] = {
	\ 'audio': '/Resources/Normal_Mode/Undo.wav',
	\ 'map_to': "exec 'normal!' v:count1 . 'u'<cr>",
\ }

" Note: redo doesn't currently support a count because the `v:count1` was giving me an error
let s:mappings['<c-r>'] = {
	\ 'audio': '/Resources/Normal_Mode/Redo.wav',
	\ 'map_to': "<c-r>",
\ }

function! auditory#AssignMappings()
	for [key, value] in items(s:mappings)
		" If this an `execute` mapping, add a pipe.
		" Otherwise <cr> to exit command mode.
		let l:pipe = match(value.map_to, 'exec') !=# -1 ? ' \| ' : '<cr>'
		
		" Default to nnoremap
		let l:cmd = has_key(value, 'map_command') ? value.map_command : 'nnoremap'
		
		" If `map_from` is specified, we can't rely on `key` to provide it
		let l:map_from = has_key(value, 'map_from') ? value.map_from : key
		
		" Default to <silent> unless the mapping explicitly calls for a value
		let l:silence = '<silent>'
		if has_key(value, 'silent')
			let l:silence = value.silent ? l:silence : ''
		endif
		
		execute l:cmd . ' ' . l:silence . ' ' . l:map_from .
			\ ' :<c-u>call auditory#Play("' . value.audio . '")' .
			\ l:pipe . value.map_to
	endfor
endfunction


" If users have a custom mapping for any of the commands we need, store the
" mapping so we can map to it after playing audio and so we can restore the
" user's mappings when the plugin is toggled off.
function! auditory#StoreUserMapping(map_from)
	if !has_key(s:mappings[a:map_from], 'user_mapping')
		let l:map_from = has_key(s:mappings[a:map_from], 'map_from') ?
			\ s:mappings[a:map_from].map_from : a:map_from
		let l:user_mapping = maparg(l:map_from)
		
		if l:user_mapping
			let s:mappings[a:map_from].user_mapping = l:user_mapping
		endif
	endif
endfunction


function! auditory#Unmap()
	for [key, value] in items(s:mappings)
		let l:cmd = has_key(value, 'map_command') ? value.map_command : 'nnoremap'
		
		if l:cmd ==# 'nnoremap'
			execute 'nunmap ' . key
		endif
	endfor
endfunction
