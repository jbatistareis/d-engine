extends GridContainer

var room : RoomTile


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setRoom")


func setRoom(value : RoomTile, soloSelect : bool) -> void:
	room = value

