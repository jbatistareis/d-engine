extends Panel

var location : Location setget setLocation


func _ready() -> void:
	self.location = Location.new()
	LocationIdGenerator.resetId()
	
	LocationEditorSignals.connect("fileOpened", self, "loadLocation")
	$saveLocation.connect("confirmed", self, "saveLocation")
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/sldEncRate.connect("value_changed", self, "changeEncRateLabel")
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/HBoxContainer/btnLoad.connect("button_up", self, "openLocationFile")
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/HBoxContainer/btnSave.connect("button_up", self, "saveLocationFile")
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/HBoxContainer/btnTest.connect("button_up", self, "testLocation")
	
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func setLocation(value : Location) -> void:
	location = value
	
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtName.text = location.name
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text = location.shortName
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text = location.description
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text = location.entranceLogic
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text = location.exitLogic
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/sldEncRate.value = location.encounterRate


func openLocationFile() -> void:
	$openLocation.popup_centered()


func saveLocationFile() -> void:
	$saveLocation.popup_centered()


func loadLocation(shortName : String) -> void:
	self.location = EntityLoader.loadLocation(shortName)
	LocationIdGenerator.adjustId(location)
	LocationEditorSignals.emit_signal("loadedLocation", location)


func saveLocation() -> void:
	location.name = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtName.text
	location.shortName = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text
	location.description = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text
	location.entranceLogic = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text
	location.exitLogic = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text
	
	location.rooms = $HSplitContainer/tiles/ScrollContainer/roomsContainer.collectRooms()
	location.portals = $HSplitContainer/properties/TabContainer/Portals.collectPortals()
	location.spawns = $HSplitContainer/properties/TabContainer/Spawns.collectSpawns()
	
	location.encounterRate = $HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/sldEncRate.value
	
	var path = EntitySaver.saveLocation(location)
	
	$fileSavedInfo.dialog_text = 'File saved as \'%s\'' % path
	$fileSavedInfo.popup_centered()


func editRoom(room : RoomTile, soloSelect : bool) -> void:
	$HSplitContainer/properties/TabContainer.current_tab = 1


func testLocation() -> void:
	GameManager.testing = true
	location.rooms = $HSplitContainer/tiles/ScrollContainer/roomsContainer.collectRooms()
	location.portals = $HSplitContainer/properties/TabContainer/Portals.collectPortals()
	location.spawns = $HSplitContainer/properties/TabContainer/Spawns.collectSpawns()
	
	$locationTest.popup_centered()
	LocationEditorSignals.emit_signal("testLocation", location, 0, 0, Enums.Direction.NORTH)


func changeEncRateLabel(value : float) -> void:
	$HSplitContainer/properties/TabContainer/Location/VBoxContainer/GridContainer/lblEncRate.text = ('Enc.: %d' % (value * 100)) + '%'

