extends Camera3D

const _ROTATE_45 : float = PI / 4
const _ROTATE_90 : float = PI / 2
# sin(rotation.y) * 2
const _SIN_TABLE : Array = [0, -2, 0, 2]
# cos(rotation.y) * 2
const _COS_TABLE : Array = [2, 0, -2, 0]

var freeFlight : bool = false

var teleportData : Dictionary = {}


func _ready() -> void:
	Signals.playerSpawned.connect(setup)
	Signals.cameraMovedForward.connect(moveCamera.bind(Enums.CameraOffsetDirection.FOWARD))
	Signals.cameraMovedBackward.connect(moveCamera.bind(Enums.CameraOffsetDirection.BACKWARD))
	Signals.cameraRotatedLeft.connect(rotateCamera.bind(Enums.CameraOffsetRotation.LEFT))
	Signals.cameraRotatedRight.connect(rotateCamera.bind(Enums.CameraOffsetRotation.RIGHT))
	Signals.cameraSnapped.connect(teleport)


func _process(_delta : float) -> void:
	if freeFlight:
		inputFreeFlight()


func setup(_location : Location, x : int, y : int, direction : int) -> void:
	current = true
	GameManager.direction = direction
	freeFlight = false
	goTo(x, y, direction)


func setupFreeFlight(location : Location, x : int, y : int, direction : int) -> void:
	setup(location, x, y, direction)
	freeFlight = true


func freeCamera() -> void:
	GameManager.cameraMoving = false


func goTo(x : int, y : int, direction : int) -> void:
	rotation.x = 0
	
	transform.origin.x = x * 2 + 1
	transform.origin.y = 1
	transform.origin.z = y * 2 + 1
	rotation.x = 0
	rotation.y = _ROTATE_90 * -direction


func teleport(x : int, y : int, direction : int) -> void:
	teleportData = {
		'x': x,
		'y': y,
		'direction': direction
	}


# use Enums.CameraOffsetDirection
func moveCamera(offsetDirection : int) -> void:
	GameManager.cameraMoving = true
	
	if !teleportData.is_empty():
		goTo(teleportData.x, teleportData.y, teleportData.direction)
		teleportData.clear()
		
		GameManager.cameraMoving = false
	else:
		var tween = create_tween()
		tween.tween_property(
			self,
			"transform:origin",
			transform.origin + (Vector3(
				_SIN_TABLE[GameManager.direction],
				0,
				_COS_TABLE[GameManager.direction]) * offsetDirection),
			GameParameters.MOVEMENT_DURATION
		)
		tween.play()
		tween.tween_callback(freeCamera)


# use Enums.CameraOffsetRotation
func rotateCamera(offsetRotation : int) -> void:
	GameManager.cameraMoving = true
	
	var tween = create_tween()
	tween.tween_property(
		self,
		"rotation:y",
		rotation.y + (_ROTATE_90 * offsetRotation),
		GameParameters.ROTATION_DURATION
	)
	tween.play()
	tween.tween_callback(freeCamera)


func inputFreeFlight() -> void:
	var elevationUp = Input.is_action_pressed("ui_page_up")
	var elevationDown = Input.is_action_pressed("ui_page_down")
	var pitchUp = Input.is_action_pressed("ui_home")
	var pitchDown = Input.is_action_pressed("ui_end")
	
	if !GameManager.cameraMoving:
		GameManager.cameraMoving = true
		
		var tween = create_tween()
		if elevationUp:
			tween.tween_property(
				self,
				"transform:origin:y",
				transform.origin.y + 2,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.play()
			tween.tween_callback(freeCamera)
		
		if elevationDown:
			tween.tween_property(
				self,
				"transform:origin:y",
				transform.origin.y - 2,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.play()
			tween.tween_callback(freeCamera)
		
		if pitchUp && (rotation.x <= _ROTATE_45):
			tween.tween_property(
				self,
				"rotation:x",
				rotation.x + _ROTATE_45,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.play()
			tween.tween_callback(freeCamera)
		
		if pitchDown && (rotation.x >= -_ROTATE_90):
			tween.tween_property(
				self,
				"rotation:x",
				rotation.x - _ROTATE_45,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.play()
			tween.tween_callback(freeCamera)

