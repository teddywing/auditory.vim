augroup auditory#insert_mode
	autocmd!
	autocmd CursorMovedI * call auditory#PlayScale()
augroup END


command! AuditoryToggleGalaxyFarFarAway call auditory#ToggleGalaxyFarFarAway()


call auditory#NormalModeMappings()
