extends Panel

var location : Location setget setLocation


func _ready() -> void:
	self.location = Location.new()
	EditorIdGenerator.resetId()
	
	LocationEditorSignals.connect("fileOpened", self, "loadLocation")
	$saveLocation.connect("confirmed", self, "saveLocation")
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/HBoxContainer/btnLoad.connect("button_up", self, "openLocationFile")
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/HBoxContainer/btnSave.connect("button_up", self, "saveLocationFile")
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/HBoxContainer/btnTest.connect("button_up", self, "testLocation")
	
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func setLocation(value : Location) -> void:
	location = value
	
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtName.text = location.name
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text = location.shortName
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text = location.description
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text = location.entranceLogic
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text = location.exitLogic


func openLocationFile() -> void:
	$openLocation.popup_centered()


func saveLocationFile() -> void:
	$saveLocation.popup_centered()


func loadLocation(shortName : String) -> void:
	self.location = EntityLoader.loadLocation(shortName)
	EditorIdGenerator.adjustId(location)
	LocationEditorSignals.emit_signal("loadedLocation", location)


func saveLocation() -> void:
	location.name = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtName.text
	location.shortName = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text
	location.description = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text
	location.entranceLogic = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text
	location.exitLogic = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text
	
	location.rooms = $HSplitContainer/Panel/ScrollContainer/roomsContainer.collectRooms()
	location.portals = $HSplitContainer/Panel2/TabContainer/Portals.collectPortals()
	location.spawns = $HSplitContainer/Panel2/TabContainer/Spawns.collectSpawns()
	
	var path = EntitySaver.saveLocation(location)
	
	$fileSavedInfo.dialog_text = 'File saved as \'%s\'' % path
	$fileSavedInfo.popup_centered()


func editRoom(room : Room, soloSelect : bool) -> void:
	$HSplitContainer/Panel2/TabContainer.current_tab = 1


func testLocation() -> void:
	GameManager.testing = true
	location.rooms = $HSplitContainer/Panel/ScrollContainer/roomsContainer.collectRooms()
	location.portals = $HSplitContainer/Panel2/TabContainer/Portals.collectPortals()
	location.spawns = $HSplitContainer/Panel2/TabContainer/Spawns.collectSpawns()
	
	$locationTest.popup_centered()
	LocationEditorSignals.emit_signal("testLocation", location, 0, 0, Enums.Direction.NORTH)

