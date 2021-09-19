class_name Overlay
extends Control


func _ready() -> void:
	Signals.connect("guiOpenWindow", self, "open")
	Signals.connect("guiCloseWindow", self, "close")


func _process(delta) -> void:
	if $foreground.get_child_count() == 0:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP


func open(window) -> void:
	addWindow(window)


func close() -> void:
	if !GuiOverlayManager.windowQueue.empty():
		removeWindow(GuiOverlayManager.windowQueue.front())
		GuiOverlayManager.windowQueue.pop_front()


func addWindow(window : GuiWindow) -> void:
	if !GuiOverlayManager.windowQueue.empty() && (window.type == Enums.GuiWindowType.FOREGROUND):
		var currentWindow = GuiOverlayManager.windowQueue.front()
		window.position = currentWindow.rect_position
		window.position += Vector2(currentWindow.rect_size.x * 1.2, 0)
	
	match window.type:
		Enums.GuiWindowType.BACKGROUND:
			$background.add_child(window)
		
		Enums.GuiWindowType.FOREGROUND:
			$foreground.add_child(window)
			GuiOverlayManager.windowQueue.push_front(window)
		
		Enums.GuiWindowType.PERMANENT:
			$permanent.add_child(window)


func removeWindow(window : GuiWindow) -> void:
	match window.type:
		Enums.GuiWindowType.BACKGROUND: # TODO wat 2 do
			pass
		
		Enums.GuiWindowType.FOREGROUND:
			$foreground.remove_child(window)
		
		Enums.GuiWindowType.PERMANENT: # TODO wat 2 do
			pass
	
	yield(get_tree(), "idle_frame")
	if $foreground.get_child_count() == 0:
		for child in $background.get_children():
			child.queue_free()

