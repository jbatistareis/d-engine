extends WindowDialog


func _enter_tree() -> void:
	var size = GuiOverlayManager.windowSize() * 0.70
	rect_min_size = size
	$ViewportContainer.rect_size = size
	$ViewportContainer/Viewport.size = size

