if exists('g:loaded_auditory')
	finish
endif
let g:loaded_auditory = 1


" Require mplayer otherwise fail
if !executable('mplayer')
	echomsg 'Auditory.vim requires `mplayer` to be installed'
	finish
endif


augroup auditory#insert_mode
	autocmd!
	autocmd CursorMovedI * call auditory#PlayScale()
augroup END


command! AuditoryToggleGalaxyFarFarAway call auditory#ToggleGalaxyFarFarAway()


call auditory#AssignMappings()
