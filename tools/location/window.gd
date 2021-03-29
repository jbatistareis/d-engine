extends Panel

var location : Location = Location.new()


func _init() -> void:
	pass


func _ready() -> void:
	LocationEditorSignals.connect("selectedTile", self, "editRoom")


func loadLocation(shortName : String) -> void:
	location = EntityLoader.loadLocation(shortName)
	LocationEditorSignals.emit_signal("loadedLocation", location)


func saveLocation() -> void:
	LocationEditorSignals.emit_signal("savedLocation", location)
	EntitySaver.saveLocation(location)


func editRoom(room : Room) -> void:
	$HSplitContainer/Panel/TabContainer.current_tab = 3


func addPortal() -> void:
	pass


func removePortal() -> void:
	pass


func addSpawn() -> void:
	pass


func removeSpawn() -> void:
	pass


func str2friendNpcs(input : String) -> Array:
	return []


func friendNpcs2str(portals : Array) -> String:
	return ''


func str2enemies(input : String) -> Array:
	return []


func enemies2str(spanws : Array) -> String:
	return ''

