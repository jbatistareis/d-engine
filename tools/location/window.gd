extends Panel

var location : Location = Location.new()


func _ready() -> void:
	EditorIdGenerator.resetId()
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func loadLocation(shortName : String) -> void:
	location = EntityLoader.loadLocation(shortName)
	EditorIdGenerator.adjustId(location)
	LocationEditorSignals.emit_signal("loadedLocation", location)


func saveLocation() -> void:
	LocationEditorSignals.emit_signal("savedLocation", location)
	EntitySaver.saveLocation(location)


func editRoom(room : Room) -> void:
	$HSplitContainer/Panel2/TabContainer.current_tab = 1

