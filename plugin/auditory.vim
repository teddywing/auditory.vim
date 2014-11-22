" Require mplayer otherwise fail
if !executable('mplayer')
	echoerr 'Auditory.vim requires `mplayer` to be installed'
	finish
endif


augroup auditory#insert_mode
	autocmd!
	autocmd CursorMovedI * call auditory#PlayScale()
augroup END


command! AuditoryToggleGalaxyFarFarAway call auditory#ToggleGalaxyFarFarAway()


call auditory#NormalModeMappings()
