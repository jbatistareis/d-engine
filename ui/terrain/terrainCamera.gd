extends Node3D

const _ROTATE_45 : float = PI / 4
const _ROTATE_90 : float = PI / 2
# sin(rotation.y) * 2
const _SIN_TABLE : Array = [0, -2, 0, 2]
# cos(rotation.y) * 2
const _COS_TABLE : Array = [2, 0, -2, 0]

var freeFlight : bool = false

var teleportData : Dictionary = {}

@onready var tween : Tween = $tween


func _ready() -> void:
	Signals.connect("playerSpawned",Callable(self,"setup"))
	Signals.connect("cameraMovedForward",Callable(self,"moveCamera").bind(Enums.CameraOffsetDirection.FOWARD))
	Signals.connect("cameraMovedBackward",Callable(self,"moveCamera").bind(Enums.CameraOffsetDirection.BACKWARD))
	Signals.connect("cameraRotatedLeft",Callable(self,"rotateCamera").bind(Enums.CameraOffsetRotation.LEFT))
	Signals.connect("cameraRotatedRight",Callable(self,"rotateCamera").bind(Enums.CameraOffsetRotation.RIGHT))
	Signals.connect("cameraSnapped",Callable(self,"teleport"))
	
	tween.connect("tween_all_completed",Callable(self,"freeCamera"))


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


func freeCamera() -> void:
	GameManager.cameraMoving = false


func goTo(x : int, y : int, direction : int) -> void:
	$camera.rotation.x = 0
	
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
		tween.interpolate_property(
			self,
			"transform:origin",
			transform.origin,
			transform.origin + (Vector3(
				_SIN_TABLE[GameManager.direction],
				0,
				_COS_TABLE[GameManager.direction]) * offsetDirection),
			GameParameters.MOVEMENT_DURATION
		)
		tween.start()


# use Enums.CameraOffsetRotation
func rotateCamera(offsetRotation : int) -> void:
	GameManager.cameraMoving = true
	
	tween.interpolate_property(
		self,
		"rotation:y",
		rotation.y,
		rotation.y + (_ROTATE_90 * offsetRotation),
		GameParameters.ROTATION_DURATION
	)
	tween.start()


func inputFreeFlight() -> void:
	var elevationUp = Input.is_action_pressed("ui_page_up")
	var elevationDown = Input.is_action_pressed("ui_page_down")
	var pitchUp = Input.is_action_pressed("ui_home")
	var pitchDown = Input.is_action_pressed("ui_end")
	
	if !tween.is_active():
		GameManager.cameraMoving = true
		
		if elevationUp:
			tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y + 2,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.start()
		
		if elevationDown:
			tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y - 2,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.start()
		
		if pitchUp && ($camera.rotation.x <= _ROTATE_45):
			tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x + _ROTATE_45,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.start()
		
		if pitchDown && ($camera.rotation.x >= -_ROTATE_90):
			tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x - _ROTATE_45,
				GameParameters.FREE_FLIGHT_DURATION
			)
			tween.start()

