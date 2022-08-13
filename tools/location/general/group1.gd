extends GridContainer

const _LABEL : String = 'Enc.: %d'


func _on_sldEncounter_value_changed(value):
	$lblEncounter.text = (_LABEL % (value * 100)) + '%'


func _on_General_loadedLocationDto(locationDto : LocationDTO):
	$txtName.text = locationDto.name
	$txtShortName.text = locationDto.shortName
	$txtDescription.text = locationDto.description
	$sldEncounter.value = locationDto.encounterRate

