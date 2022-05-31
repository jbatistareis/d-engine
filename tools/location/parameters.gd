extends TabContainer


func _ready() -> void:
	set_tab_disabled(1, true)


func _on_grid_selectedRoom(room : Dictionary):
	if !room.empty():
		set_tab_disabled(1, false)
		current_tab = 1

