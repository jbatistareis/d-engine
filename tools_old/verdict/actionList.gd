extends VBoxContainer


func reorderUp(item : CenterContainer) -> void:
	var index = get_children().find(item)
	
	if index > 0:
		move_child(item, get_children().find(item) - 1)


func reorderDown(item : CenterContainer) -> void:
	var index = get_children().find(item)
	
	if index < get_child_count():
		move_child(item, get_children().find(item) + 1)

