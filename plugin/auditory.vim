if exists('g:loaded_auditory')
	finish
endif
let g:loaded_auditory = 1


" Require mplayer otherwise fail
if !executable('mplayer')
	echomsg 'Auditory.vim requires `mplayer` to be installed'
	finish
endif


if !exists('g:auditory_on')
	let g:auditory_on = 0
endif

if !exists('g:auditory_galaxy_far_far_away')
	let g:auditory_galaxy_far_far_away = 0
endif


command! AuditoryOn call auditory#AssignMappings()
command! AuditoryOff call auditory#Unmap()
command! AuditoryToggle call auditory#ToggleMappings()
command! AuditoryToggleGalaxyFarFarAway call auditory#ToggleGalaxyFarFarAway()


if g:auditory_on
	call auditory#AssignMappings()
endif

if g:auditory_galaxy_far_far_away
	let g:auditory_galaxy_far_far_away = 0
	call auditory#ToggleGalaxyFarFarAway()
endif
