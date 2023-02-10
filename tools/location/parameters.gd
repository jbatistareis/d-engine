extends TabContainer


func _ready() -> void:
	EditorSignals.connect("mapSelectedRoom",Callable(self,"selectedRoom"))
	EditorSignals.connect("mapSelectedMultiRooms",Callable(self,"selectedMultiRooms"))

func selectedRoom(room : Dictionary):
	if !room.is_empty():
		current_tab = 1


func selectedMultiRooms(rooms : Array):
	if !rooms.is_empty():
		current_tab = 1

