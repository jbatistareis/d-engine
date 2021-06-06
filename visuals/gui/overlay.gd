extends Control


func _process(delta) -> void:
	if get_child_count() == 0:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func addWindow(window : GuiWindowModel) -> void:
	var newWindowPosition = Vector2.ZERO
	
	if !WindowManager.windowQueue.empty():
		var currentWindow = WindowManager.windowQueue.front()
		newWindowPosition = currentWindow.rect_position
		newWindowPosition += Vector2(
			currentWindow.rect_size.x / 1.5,
			0)
	
	window.rect_position = newWindowPosition
	add_child(window)

