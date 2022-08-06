extends TabContainer


func _on_grid_selectedMultiRoom(rooms : Array):
	if !rooms.empty():
		if !rooms[0].empty():
			current_tab = 1


func _on_grid_altSelectionActive():
	current_tab = 1

