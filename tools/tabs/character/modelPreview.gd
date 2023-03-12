extends Node3D

const _ROTATION : float = PI / 4


func _ready() -> void:
	ToolSignals.previewedModel.connect(_view)


func _view(shortName : String) -> void:
	for node in $modelArea.get_children():
		node.queue_free()
	
	var model = load(GamePaths.CHARACTER_MODEL % shortName)
	
	$modelArea.add_child(model.instantiate())
	$pivot.rotation.y = 0


func _rotatePivot(angle : float) -> void:
	var tween = create_tween()
	
	tween.tween_property($pivot, "rotation:y", $pivot.rotation.y + angle, 0.1)
	tween.play()
	
	await tween.finished


func rotateLeft() -> void:
	_rotatePivot(_ROTATION)


func rotateRight() -> void:
	_rotatePivot(-_ROTATION)

