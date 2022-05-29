extends Tabs

signal loadedLocationDto(locationDto)

var locationDto : LocationDTO setget setLocationDto


func _ready() -> void:
	self.locationDto = LocationDTO.new()


func setLocationDto(value : LocationDTO) -> void:
	locationDto = value
	$background/mainDivider/map/scroll/grid.loadRooms(locationDto.roomDicts)
	
	emit_signal("loadedLocationDto", locationDto)


func updateLocation() -> void:
	locationDto.entranceLogic = $"background/mainDivider/parameters/General/mainContainer/logic/Entrance logic/txtEntranceLogic".text
	locationDto.exitLogic = $"background/mainDivider/parameters/General/mainContainer/logic/Exit logic/txtExitLogic".text
	
	locationDto.roomDicts.clear()
	locationDto.portals.clear()
	locationDto.spawns.clear()
	
	for cell in $background/mainDivider/map/scroll/grid.get_children():
		var roomDict = cell.roomDict
		
		if roomDict.type != Enums.RoomType.DUMMY:
			locationDto.roomDicts.append(roomDict)


func test() -> void:
	updateLocation()
	var location = Location.new().fromDTO(locationDto)


func saveLocation() -> void:
	Persistence.saveDTO(locationDto)


# parameter listeners
func _on_sldEncounter_value_changed(value):
	locationDto.encounterRate = value


func _on_txtName_text_changed(new_text):
	locationDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	locationDto.shortName = new_text


func _on_txtDescription_text_changed(new_text):
	locationDto.description = new_text
