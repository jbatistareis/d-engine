extends Window


func _on_previewWindow_about_to_show():
	var size = GuiOverlayManager.currentSize * 0.7
	
	custom_minimum_size = size
	$SubViewportContainer.size = size
	$SubViewportContainer/SubViewport.size = size
	
	$SubViewportContainer/SubViewport/terrain.visible = true


func _on_previewWindow_popup_hide():
	$SubViewportContainer/SubViewport/terrain.visible = false

