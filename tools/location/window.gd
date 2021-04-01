extends Panel

var location : Location setget setLocation


func _ready() -> void:
	self.location = Location.new()
	
	EditorIdGenerator.resetId()
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func setLocation(value : Location) -> void:
	location = value
	
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtName.text = location.name
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtShortName.text = location.shortName
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/GridContainer/txtDescription.text = location.description
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtEntranceLogic.text = location.entranceLogic
	$HSplitContainer/Panel2/TabContainer/Location/VBoxContainer/VBoxContainer/txtExitLogic.text = location.exitLogic



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
	
	LocationEditorSignals.emit_signal("savedLocation", location)
	EntitySaver.saveLocation(location)


func editRoom(room : Room) -> void:
	$HSplitContainer/Panel2/TabContainer.current_tab = 1

