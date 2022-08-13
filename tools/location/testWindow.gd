extends WindowDialog


func _on_previewWindow_about_to_show():
	var size = GuiOverlayManager.currentSize * 0.7
	
	rect_min_size = size
	$ViewportContainer.rect_size = size
	$ViewportContainer/Viewport.size = size
	
	$ViewportContainer/Viewport/terrain.visible = true


func _on_previewWindow_popup_hide():
	$ViewportContainer/Viewport/terrain.visible = false

