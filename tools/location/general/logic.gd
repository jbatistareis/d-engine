extends TabContainer


func _on_locationTab_loadedLocationDto(locationDto : LocationDTO):
	$"Entrance logic/txtEntranceLogic".text = locationDto.entranceLogic
	$"Exit logic/txtExitLogic".text = locationDto.exitLogic
	

