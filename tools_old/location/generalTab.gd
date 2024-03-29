extends TabBar

signal loadedLocationDto(locationDto)

const _SAVE_MESSAGE : String = 'Do you wish to save/overwrite the file \'%s\'?'
const _PREVIEW_TITLE : String = '%s (%s) preview'

var locationDto : LocationDTO : set = setLocationDto


func _ready() -> void:
	var dummyLocation = LocationDTO.new()
	dummyLocation.rooms.clear()
	
	self.locationDto = dummyLocation


func setLocationDto(value : LocationDTO) -> void:
	locationDto = value
	get_node("../../map/scroll/container/grid").loadRooms(locationDto.rooms)
	
	emit_signal("loadedLocationDto", locationDto)


func updateLocation() -> void:
	locationDto.entranceLogic = $mainContainer/logic/Entrance/txtEntranceLogic.text
	locationDto.exitLogic = $mainContainer/logic/Exit/txtExitLogic.text
	
	locationDto.rooms.clear()
	
	locationDto.rooms = get_node("../../map/scroll/container/grid").collectRooms()


# parameter listeners
func _on_sldEncounter_value_changed(value):
	locationDto.encounterRate = value


func _on_txtName_text_changed(new_text):
	locationDto.name = new_text


func _on_txtShortName_text_changed(new_text : String):
	locationDto.shortName = new_text
	$mainContainer/buttons/btnSave.disabled = new_text.is_empty()


func _on_txtDescription_text_changed(new_text):
	locationDto.description = new_text


# button listeners
func _on_btnSave_pressed():
	var saveConfirmation = get_node("../../../../saveConfirmation")
	saveConfirmation.dialog_text = _SAVE_MESSAGE % locationDto.shortName
	saveConfirmation.popup_centered()


func _on_saveConfirmation_confirmed():
	updateLocation()
	Persistence.saveDTO(locationDto)


func _on_btnPreview_pressed():
	GameManager.testing = true
	updateLocation()
	var location = Location.new().fromDTO(locationDto)
	
	var previewWindow = get_node("../../../../previewWindow")
	previewWindow.window_title = _PREVIEW_TITLE % [location.name, location.shortName]
	previewWindow.popup_centered()
	
	Signals.emit_signal("playerSpawned", location, 0, 0, Enums.Direction.NORTH)


func _on_btnOpen_pressed():
	get_node("../../../../openWindow").popup_centered()
	
	var lst = get_node("../../../../openWindow/VBoxContainer/ScrollContainer/lstFiles")
	lst.clear()
	
	for item in Persistence.listEntities(Enums.EntityType.LOCATION):
		lst.add_item(item)


func _on_btnCancel_pressed():
	get_node("../../../../openWindow").hide()


func _on_btnOpenConfirm_pressed():
	var lst = get_node("../../../../openWindow/VBoxContainer/ScrollContainer/lstFiles")
	if lst.is_anything_selected():
		var shortName = lst.get_item_text(lst.get_selected_items()[0])
		self.locationDto = Persistence.loadDTO(shortName, Enums.EntityType.LOCATION)
		
		get_node("../../../../openWindow").hide()

