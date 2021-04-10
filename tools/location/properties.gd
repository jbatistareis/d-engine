extends GridContainer

var room : Room


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setRoom")


func setRoom(value : Room, soloSelect : bool) -> void:
	room = value

