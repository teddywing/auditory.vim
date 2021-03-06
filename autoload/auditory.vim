" Get the script path so we can resolve the audio file paths
let s:script_path = resolve(expand('<sfile>:p:h')) . '/..'


" Play audio
" ==========

function! auditory#Play(file)
	call system("mplayer " . s:script_path . a:file . " &")
endfunction


" Insert mode
" ===========

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


function! auditory#AssignInsertMappings()
	let g:auditory_galaxy_far_far_away = !g:auditory_galaxy_far_far_away
	call auditory#ToggleGalaxyFarFarAway()
endfunction


function! auditory#UnmapInsert()
	augroup auditory#insert_mode
		autocmd!
	augroup END
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


function! auditory#ToggleGalaxyFarFarAway()
	if g:auditory_galaxy_far_far_away
		augroup auditory#insert_mode
			autocmd!
			autocmd CursorMovedI * call auditory#PlayScale()
		augroup END
		let g:auditory_galaxy_far_far_away = 0
	else
		augroup auditory#insert_mode
			autocmd!
			autocmd CursorMovedI * call <SID>GalaxyFarFarAway()
		augroup END
		let g:auditory_galaxy_far_far_away = 1
	endif
endfunction


" Operators
" =========

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

let g:auditory_mappings = {}
let g:auditory_mappings['h'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['j'] = {
	\ 'audio': '/Resources/Normal_Mode/Down.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['k'] = {
	\ 'audio': '/Resources/Normal_Mode/Up.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['l'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['gj'] = {
	\ 'audio': '/Resources/Normal_Mode/Down.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['gk'] = {
	\ 'audio': '/Resources/Normal_Mode/Up.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['<space>'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }

" FIXME: allow counts on the delete key
let g:auditory_mappings['<bs>'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
\ }

let g:auditory_mappings['0'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
\ }
let g:auditory_mappings['^'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['_'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['$'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['g_'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['%'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }

let g:auditory_mappings['b'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['w'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['e'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['B'] = {
	\ 'audio': '/Resources/Normal_Mode/Left.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['W'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['E'] = {
	\ 'audio': '/Resources/Normal_Mode/Right.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['p'] = {
	\ 'audio': '/Resources/Normal_Mode/Paste.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['P'] = {
	\ 'audio': '/Resources/Normal_Mode/Paste.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['/'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
\ }
let g:auditory_mappings['n'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
\ }
let g:auditory_mappings['N'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
\ }
let g:auditory_mappings['#'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
\ }
let g:auditory_mappings['*'] = {
	\ 'audio': '/Resources/Normal_Mode/Search.wav',
	\ 'silent': 0,
\ }

let g:auditory_mappings['zt'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['z.'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['zz'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['zb'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }

" FIXME: Allow these scrolling commands to support counts. Was getting errors constructing them the other way
let g:auditory_mappings['<c-d>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['<c-u>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['<c-f>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }

" FIXME: need to press <c-b> twice in order for it to work
let g:auditory_mappings['<c-b>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }

let g:auditory_mappings['H'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['M'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }
let g:auditory_mappings['L'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
\ }

let g:auditory_mappings['('] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings[')'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['{'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['}'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['<c-i>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['<c-o>'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }

let g:auditory_mappings['gg'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['G'] = {
	\ 'audio': '/Resources/Normal_Mode/Jump.wav',
	\ 'count': 0,
\ }

let g:auditory_mappings['x'] = {
	\ 'audio': '/Resources/Normal_Mode/Delete.wav',
	\ 'count': 1,
\ }
let g:auditory_mappings['v_x'] = {
	\ 'audio': '/Resources/Normal_Mode/Delete.wav',
	\ 'map_command': 'vnoremap',
	\ 'map_from': 'x',
	\ 'count': 1,
\ }

let g:auditory_mappings['d'] = {
	\ 'map_to': ':set opfunc=<SID>Delete<CR>g@',
	\ 'silence': 1,
\ }
let g:auditory_mappings['v_d'] = {
	\ 'map_from': 'd',
	\ 'map_to': ':<C-U>call <SID>Delete(visualmode(), 1)<CR>',
	\ 'map_command': 'vnoremap',
	\ 'silence': 1,
\ }

let g:auditory_mappings['dd'] = {
	\ 'map_to': ':set opfunc=<SID>DeleteLine<CR>g@$',
	\ 'silence': 1,
\ }

" nnoremap <silent> d :<c-u>call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . 'd'<cr>
" nnoremap <silent> d :<c-u>set opfunc=d \| call auditory#Play('/Resources/Normal_Mode/Delete.wav') \| exec 'normal!' v:count1 . @g<cr>

" inoremap <silent> <c-p> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-p><c-p>
" inoremap <silent> <c-n> <esc>:<c-u>call auditory#Play('/Resources/auto_complete.wav')<cr>a<c-n><c-n>

let g:auditory_mappings['u'] = {
	\ 'audio': '/Resources/Normal_Mode/Undo.wav',
	\ 'count': 1,
\ }

" Note: redo doesn't currently support a count because the `v:count1` was giving me an error
let g:auditory_mappings['<c-r>'] = {
	\ 'audio': '/Resources/Normal_Mode/Redo.wav',
\ }

function! auditory#AssignMappings()
	if !g:auditory_on
		for [key, value] in items(g:auditory_mappings)
			call auditory#StoreUserMapping(key)
			
			" Default to nnoremap
			let l:cmd = has_key(value, 'map_command') ? value.map_command : 'nnoremap'
			
			" If `map_from` is specified, we can't rely on `key` to provide it
			let l:map_from = has_key(value, 'map_from') ? value.map_from : key
			
			if has_key(value, 'audio')
				let l:audio = ':<c-u>call auditory#Play("' . value.audio . '")'
			else
				let l:audio = ''
			endif
			
			" Map to key unless a `map_to` or user mapping is defined
			if has_key(value, 'map_to')
				let l:map_to = value.map_to
			else
				if has_key(value, 'user_mapping')
					let l:map_to = value.user_mapping
				else
					let l:map_to = key
				endif
			endif
			
			if has_key(value, 'count')
				let vcount = value.count ==# 1 ? 'v:count1' : 'v:count'
				let l:map_to_with_count = "execute 'normal!' " . vcount . " . '" . l:map_to . "'<cr>"
			else
				let l:map_to_with_count = l:map_to
			endif
			
			" If this an `execute` mapping, add a pipe.
			" Otherwise <cr> to exit command mode.
			if l:audio !=# ''
				let l:pipe = match(l:map_to_with_count , 'exec') !=# -1 ? ' \| ' : '<cr>'
			else
				let l:pipe = ''
			endif
			
			" Default to <silent> unless the mapping explicitly calls for a value
			let l:silence = '<silent>'
			if has_key(value, 'silent')
				let l:silence = value.silent ? l:silence : ''
			endif
			
			execute l:cmd . ' ' . l:silence . ' ' . l:map_from .
				\ ' ' .
				\ l:audio .
				\ l:pipe .
				\ l:map_to_with_count
		endfor
		
		call auditory#AssignInsertMappings()
		
		let g:auditory_on = 1
	endif
endfunction


" If users have a custom mapping for any of the commands we need, store the
" mapping so we can map to it after playing audio and so we can restore the
" user's mappings when the plugin is toggled off.
function! auditory#StoreUserMapping(map_from)
	if !has_key(g:auditory_mappings[a:map_from], 'user_mapping')
		let l:map_from = has_key(g:auditory_mappings[a:map_from], 'map_from') ?
			\ g:auditory_mappings[a:map_from].map_from : a:map_from
		let l:map_mode = has_key(g:auditory_mappings[a:map_from], 'map_command') ?
			\ g:auditory_mappings[a:map_from].map_command[0] : 'n'
		let l:user_mapping = maparg(l:map_from, l:map_mode)
		
		if l:user_mapping !=# ''
			let g:auditory_mappings[a:map_from].user_mapping = l:user_mapping
		endif
	endif
endfunction


function! auditory#Unmap()
	if g:auditory_on
		for [key, value] in items(g:auditory_mappings)
			let l:cmd = has_key(value, 'map_command') ? value.map_command : 'nnoremap'
			let l:key = has_key(value, 'map_from') ? value.map_from : key
			let l:user_mapping = get(value, 'user_mapping', '')
			
			execute l:cmd[0] . 'unmap ' . l:key
			
			if l:user_mapping !=# ''
				execute l:cmd . ' ' . get(value, 'map_from', key) . ' ' . value.user_mapping
			endif
		endfor
		
		call auditory#UnmapInsert()
		
		let g:auditory_on = 0
	endif
endfunction


function! auditory#ToggleMappings()
	if g:auditory_on
		call auditory#Unmap()
	else
		call auditory#AssignMappings()
	endif
endfunction
