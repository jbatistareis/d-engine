extends Spatial

const _ROTATE_ORIENTATION : float = PI / 2
const _ROTATE_BUTTON : float = PI / 4

const _MODEL_FILE : String = GamePaths.LOCATION_MODELS + '%s.tscn'

var blocks : Dictionary = {}


func rotatePivot(angle : float) -> void:
	if !$Tween.is_active():
		$Tween.interpolate_property(
			$pivot,
			'rotation:y',
			$pivot.rotation.y,
			$pivot.rotation.y + angle,
			0.1)
		$Tween.start()


func _on_Room_changeModel(locationShortName : String, model : String, orientation : int) -> void:
	visible = true
	
	for node in $blockArea.get_children():
		node.queue_free()
	
	$blockArea.add_child(load(_MODEL_FILE % [locationShortName, model]).instance())
	$pivot.rotation.y = (_ROTATE_ORIENTATION * orientation) + _ROTATE_BUTTON



func _on_btnPreview_pressed():
	visible = false


func _on_previewWindow_popup_hide():
	visible = true


func _on_btnRotateL_pressed():
	rotatePivot(-_ROTATE_BUTTON)


func _on_btnRotateR_pressed():
	rotatePivot(_ROTATE_BUTTON)

