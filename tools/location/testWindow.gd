extends WindowDialog


func _enter_tree() -> void:
	var size = GuiOverlayManager.windowSize() * 0.70
	rect_min_size = size
	$ViewportContainer.rect_size = size
	$ViewportContainer/Viewport.size = size


func _on_previewWindow_about_to_show():
	$ViewportContainer/Viewport/terrain.visible = true


func _on_previewWindow_popup_hide():
	$ViewportContainer/Viewport/terrain.visible = false

