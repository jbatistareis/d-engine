extends Tabs

func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func editRoom(room : Room) -> void:
	$VBoxContainer/HBoxContainer/lblId.text = ('ID: %d  /  x: %d, y: %d' % [room.id, room.x, room.y])

