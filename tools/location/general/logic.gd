extends TabContainer


func _on_General_loadedLocationDto(locationDto : LocationDTO):
	$"Entrance/txtEntranceLogic".text = locationDto.entranceLogic
	$"Exit/txtExitLogic".text = locationDto.exitLogic

