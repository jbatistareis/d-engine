extends Node3D

const _ROTATION : float = PI / 4


func _ready() -> void:
	ToolSignals.previewTile.connect(_view)


func _view(locationShortName : String, modelName : String) -> void:
	for node in $modelArea.get_children():
		node.queue_free()
	
	var model = load((GamePaths.LOCATION_MODELS + "/%s.tscn") % [locationShortName, modelName])
	
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

