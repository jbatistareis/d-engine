extends TabContainer


func _ready() -> void:
	EditorSignals.connect("mapSelectedRoom", self, "selectedRoom")
	EditorSignals.connect("mapSelectedMultiRooms", self, "selectedMultiRooms")

func selectedRoom(room : Dictionary):
	if !room.empty():
		current_tab = 1


func selectedMultiRooms(rooms : Array):
	if !rooms.empty():
		current_tab = 1

