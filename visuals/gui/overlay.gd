extends Control


func _process(delta) -> void:
	if get_child_count() == 0:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func addWindow(window : GuiWindowModel) -> void:
	if !WindowManager.windowQueue.empty():
		var currentWindow = WindowManager.windowQueue.front()
		window.position = currentWindow.rect_position
		window.position += Vector2(
			currentWindow.rect_size.x * 1.2,
			0)
	
	add_child(window)


func removeWindow(window : GuiWindowModel) -> void:
	remove_child(window)

