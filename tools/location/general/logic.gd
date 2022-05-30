extends TabContainer


func _on_locationTab_loadedLocationDto(locationDto : LocationDTO):
	$"Entrance/txtEntranceLogic".text = locationDto.entranceLogic
	$"Exit/txtExitLogic".text = locationDto.exitLogic
	

