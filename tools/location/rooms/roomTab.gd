extends Tabs

func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "editRoom")


func editRoom(room : Room) -> void:
	$ScrollContainer/VBoxContainer/lblId.text = 'ID: ' + str(room.id)
