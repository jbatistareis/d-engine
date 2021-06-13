extends Control


func _process(delta) -> void:
	if $foreground.get_child_count() == 0:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func addWindow(window : GuiWindowModel) -> void:
	if !WindowManager.windowQueue.empty() && window.foreground:
		var currentWindow = WindowManager.windowQueue.front()
		window.position = currentWindow.rect_position
		window.position += Vector2(
			currentWindow.rect_size.x * 1.2,
			0)
	
	if window.foreground:
		$foreground.add_child(window)
	else:
		$background.add_child(window)


func removeWindow(window : GuiWindowModel) -> void:
	if window.foreground:
		$foreground.remove_child(window)
	
	yield(get_tree(), "idle_frame")
	if $foreground.get_child_count() == 0:
		for child in $background.get_children():
			child.queue_free()

