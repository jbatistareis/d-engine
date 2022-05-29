extends Tabs

signal loadedLocationDto(locationDto)

const _SAVE_MESSAGE : String = 'Do you wish to save/overwrite the file \'%s\'?'
const _PREVIEW_TITLE : String = '%s (%s) preview'

var locationDto : LocationDTO setget setLocationDto


func _ready() -> void:
	self.locationDto = LocationDTO.new()


func setLocationDto(value : LocationDTO) -> void:
	locationDto = value
	$background/mainDivider/map/scroll/grid.loadRooms(locationDto.roomDicts)
	
	emit_signal("loadedLocationDto", locationDto)


func updateLocation() -> void:
	# this is a fugly fix for an UI bug that occurs on long lines
	var txtEntranceLogic = ("background/mainDivider/parameters/General/mainContainer" 
		+ "/logic/Entrance logic/txtEntranceLogic")
	var txtExitLogic = ("background/mainDivider/parameters/General/mainContainer" 
		+ "/logic/Exit logic/txtExitLogic")
	
	locationDto.entranceLogic = get_node(txtEntranceLogic).text
	locationDto.exitLogic = get_node(txtExitLogic).text
	
	locationDto.roomDicts.clear()
	locationDto.portals.clear()
	locationDto.spawns.clear()
	
	for cell in $background/mainDivider/map/scroll/grid.get_children():
		var roomDict = cell.roomDict
		
		if roomDict.type != Enums.RoomType.DUMMY:
			locationDto.roomDicts.append(roomDict)


# parameter listeners
func _on_sldEncounter_value_changed(value):
	locationDto.encounterRate = value


func _on_txtName_text_changed(new_text):
	locationDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	locationDto.shortName = new_text


func _on_txtDescription_text_changed(new_text):
	locationDto.description = new_text


# button listeners
func _on_btnSave_pressed():
	$saveConfirmation.dialog_text = _SAVE_MESSAGE % locationDto.shortName
	$saveConfirmation.popup_centered()


func _on_saveConfirmation_confirmed():
	updateLocation()
	Persistence.saveDTO(locationDto)


func _on_btnPreview_pressed():
	GameManager.testing = true
	updateLocation()
	var location = Location.new().fromDTO(locationDto)
	
	$previewWindow.window_title = _PREVIEW_TITLE % [location.name, location.shortName]
	$previewWindow.popup_centered()
	Signals.emit_signal("playerSpawned", location, 0, 0, Enums.Direction.NORTH)



func _on_btnOpen_pressed():
	$openWindow.popup_centered()

