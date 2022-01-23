extends Spatial

var freeFlight : bool = false

const ROTATE_45 : float = PI / 4
const ROTATE_90 : float = PI / 2


func _ready() -> void:
	Signals.connect("playerSpawned", self, "setup")
	Signals.connect("cameraMovedForward", self, "moveForward")
	Signals.connect("cameraMovedBackward", self, "moveBackward")
	Signals.connect("cameraRotatedLeft", self, "rotateLeft")
	Signals.connect("cameraRotatedRight", self, "rotateRight")
	LocationEditorSignals.connect("testLocation", self, "setupFreeFlight")


func _process(delta : float) -> void:
	if freeFlight:
		inputFreeFlight()


func setup(location : Location, x : int, y : int, direction : int) -> void:
	$camera.current = true
	GameManager.direction = direction
	freeFlight = false
	goTo(x, y, direction)


func setupFreeFlight(location : Location, x : int, y : int, direction : int) -> void:
	setup(location, x, y, direction)
	freeFlight = true


func goTo(x : int, y : int, direction : int) -> void:
	$camera.rotation.x = 0
	
	transform.origin.x = x * 2 + 1
	transform.origin.y = 1
	transform.origin.z = y * 2 + 1
	rotation.x = 0
	rotation.y = ROTATE_90 * -direction


func moveForward() -> void:
	GameManager.cameraMoving = true
	
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"transform:origin",
			transform.origin,
			transform.origin - Vector3(
				sin(rotation.y) * 2,
				0,
				cos(rotation.y) * 2),
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		$tween.start()
		yield($tween, "tween_all_completed")
	
	GameManager.cameraMoving = false


func moveBackward() -> void:
	GameManager.cameraMoving = true
	
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"transform:origin",
			transform.origin,
			transform.origin + Vector3(
				sin(rotation.y) * 2,
				0,
				cos(rotation.y) * 2),
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		$tween.start()
		yield($tween, "tween_all_completed")
	
	GameManager.cameraMoving = false


func rotateLeft() -> void:
	GameManager.cameraMoving = true
	
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"rotation:y",
			rotation.y,
			rotation.y + ROTATE_90,
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		$tween.start()
		yield($tween, "tween_all_completed")
	
	GameManager.cameraMoving = false


func rotateRight() -> void:
	GameManager.cameraMoving = true
	
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"rotation:y",
			rotation.y,
			rotation.y - ROTATE_90,
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		$tween.start()
		yield($tween, "tween_all_completed")
	
	GameManager.cameraMoving = false


func inputFreeFlight() -> void:
	var elevationUp = Input.is_action_pressed("ui_page_up")
	var elevationDown = Input.is_action_pressed("ui_page_down")
	var pitchUp = Input.is_action_pressed("ui_home")
	var pitchDown = Input.is_action_pressed("ui_end")
	
	if !$tween.is_active():
		GameManager.cameraMoving = true
		
		if elevationUp:
			$tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y + 2,
				0.25,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT_IN
			)
			$tween.start()
			yield($tween, "tween_all_completed")
		
		if elevationDown:
			$tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y - 2,
				0.25,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT_IN
			)
			$tween.start()
			yield($tween, "tween_all_completed")
		
		if pitchUp && ($camera.rotation.x <= ROTATE_45):
			$tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x + ROTATE_45,
				0.25,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT_IN
			)
			$tween.start()
			yield($tween, "tween_all_completed")
		
		if pitchDown && ($camera.rotation.x >= -ROTATE_90):
			$tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x - ROTATE_45,
				0.25,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT_IN
			)
			$tween.start()
			yield($tween, "tween_all_completed")
		
		GameManager.cameraMoving = false
