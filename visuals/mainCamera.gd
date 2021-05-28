extends Spatial

var direction : int setget setDirection

var freeFlight : bool = false

const ROTATE_45 : float = PI / 4
const ROTATE_90 : float = PI / 2


func _ready() -> void:
	Signals.connect("playerSpawned", self, "setup")
	Signals.connect("playerMovedForward", self, "moveForward")
	Signals.connect("playerMovedBackward", self, "moveBackward")
	Signals.connect("playerRotatedLeft", self, "rotateLeft")
	Signals.connect("playerRotatedRight", self, "rotateRight")
	LocationEditorSignals.connect("testLocation", self, "setupFreeFlight")

func _process(delta : float) -> void:
	if freeFlight:
		inputFreeFlight()


func setDirection(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	direction = correctedValue % 4


func setup(location : Location, x : int, y : int, direction : int) -> void:
	$camera.current = true
	GameManager.direction = direction
	freeFlight = false
	goTo(x, y, direction)


func setupFreeFlight(location : Location, x : int, y : int, direction : int) -> void:
	setup(location, x, y, direction)
	freeFlight = true


func goTo(x : int, y : int, direction : int) -> void:
	transform.origin.x = x * 2 + 1
	transform.origin.y = 1
	transform.origin.z = y * 2 + 1
	rotation.x = 0
	rotation.y = ROTATE_90 * direction


func moveForward() -> void:
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"transform:origin",
			transform.origin,
			transform.origin - Vector3(
				sin(rotation.y) * 2,
				0,
				cos(rotation.y) * 2),
			0.25
		)
		$tween.start()


func moveBackward() -> void:
	if !$tween.is_active():
		$tween.interpolate_property(
			self,
			"transform:origin",
			transform.origin,
			transform.origin + Vector3(
				sin(rotation.y) * 2,
				0,
				cos(rotation.y) * 2),
			0.25
		)
		$tween.start()


func rotateLeft() -> void:
	if !$tween.is_active():
		GameManager.direction -= 1
		
		$tween.interpolate_property(
			self,
			"rotation:y",
			rotation.y,
			rotation.y + ROTATE_90,
			0.25
		)
		$tween.start()


func rotateRight() -> void:
	if !$tween.is_active():
		GameManager.direction += 1
		
		$tween.interpolate_property(
			self,
			"rotation:y",
			rotation.y,
			rotation.y - ROTATE_90,
			0.25
		)
		$tween.start()


func inputFreeFlight() -> void:
	var elevationUp = Input.is_action_pressed("ui_page_up")
	var elevationDown = Input.is_action_pressed("ui_page_down")
	var pitchUp = Input.is_action_pressed("ui_home")
	var pitchDown = Input.is_action_pressed("ui_end")
	
	if !$tween.is_active():
		if elevationUp:
			$tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y + 2,
				0.25
			)
			$tween.start()
		
		if elevationDown:
			$tween.interpolate_property(
				self,
				"transform:origin:y",
				transform.origin.y,
				transform.origin.y - 2,
				0.25
			)
			$tween.start()
		
		if pitchUp:
			$tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x + (ROTATE_45 if $camera.rotation.x <= ROTATE_45 else 0),
				0.25
			)
			$tween.start()
		
		if pitchDown:
			$tween.interpolate_property(
				$camera,
				"rotation:x",
				$camera.rotation.x,
				$camera.rotation.x - (ROTATE_45 if $camera.rotation.x > -ROTATE_90 else 0),
				0.25
			)
			$tween.start()

