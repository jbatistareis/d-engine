extends Panel

var location : Location setget setLocation


func _ready() -> void:
	self.location = Location.new()
	
	EditorIdGenerator.resetId()
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")
	
	$openLocation.current_dir = GamePaths.LOCATION
	$saveLocation.current_dir = GamePaths.LOCATION
	
	$openLocation.connect("file_selected", self, "loadLocation")
	$saveLocation.connect("file_selected", self, "saveLocation")
	
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/HBoxContainer/btnLoad.connect("button_up", self, "openLocationFile")
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/HBoxContainer/btnSave.connect("button_up", self, "saveLocationFile")


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
	$saveLocation.current_file = location.shortName + '.loc'
	$saveLocation.popup_centered()


func loadLocation(path : String) -> void:
	self.location = EntityLoader.loadLocationFromPath(path)
	EditorIdGenerator.adjustId(location)
	LocationEditorSignals.emit_signal("loadedLocation", location)


func saveLocation(path : String) -> void:
	location.name = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtName.text
	location.shortName = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text
	location.description = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text
	location.entranceLogic = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text
	location.exitLogic = $HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text
	
	LocationEditorSignals.emit_signal("savedLocation", location)
	EntitySaver.saveLocationOnPath(location, path)


func editRoom(room : Room) -> void:
	$HSplitContainer/Panel2/TabContainer.current_tab = 1

