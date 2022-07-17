extends TabContainer


func _ready() -> void:
	set_tab_disabled(1, true)


func _on_grid_selectedMultiRoom(rooms : Array):
	if !rooms.empty():
		if !rooms[0].empty():
			set_tab_disabled(1, false)
			current_tab = 1

