extends GridContainer

var room : Room setget setRoom


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setRoom")


func setRoom(value : Room) -> void:
	room = value

