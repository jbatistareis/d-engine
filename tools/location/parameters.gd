extends TabContainer


func _ready() -> void:
	set_tab_disabled(1, true)


func goToRoomTab() -> void:
	set_tab_disabled(1, false)
	current_tab = 1


func _on_grid_selectedRoom(room : Dictionary):
	if !room.empty():
		goToRoomTab()


func _on_grid_selectedMultiRoom(rooms : Array):
	if !rooms.empty():
		goToRoomTab()

