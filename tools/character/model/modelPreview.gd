extends Node3D

const _ROTATE_BUTTON : float = PI / 4


func view(model : Node3D) -> void:
	for node in $blockArea.get_children():
		node.queue_free()
	
	$blockArea.add_child(model)
	$pivot.rotation.y = 0


func rotatePivot(angle : float) -> void:
	if !$Tween.is_active():
		$Tween.interpolate_property(
			$pivot,
			'rotation:y',
			$pivot.rotation.y,
			$pivot.rotation.y + angle,
			0.1)
		$Tween.start()


func _on_btnRotateL_pressed():
	rotatePivot(_ROTATE_BUTTON)


func _on_btnRotateR_pressed():
	rotatePivot(-_ROTATE_BUTTON)

