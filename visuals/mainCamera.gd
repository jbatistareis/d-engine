extends Camera

var direction : int setget setDirection

var freeFlight : bool = false

var rotate45 : float = PI / 4
var rotate90 : float = PI / 2


func _ready() -> void:
	Signals.connect("playerSpawned", self, "setup")
	Signals.connect("playerChangedRoom", self, "moveForwardBackward")
	LocationEditorSignals.connect("testLocation", self, "setupFreeFlight")


func _process(delta : float) -> void:
	input()
	
	if freeFlight:
		inputFreeFlight()


func setDirection(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	direction = correctedValue % 4


func setup(location : Location, x : int, y : int, direction : int) -> void:
	self.direction = direction
	freeFlight = false
	goTo(x, y, direction)


func setupFreeFlight(location : Location, x : int, y : int, direction : int) -> void:
	setup(location, x, y, direction)
	freeFlight = true


func goTo(x : int, y : int, direction : int) -> void:
	transform.origin.x = x * 2
	transform.origin.y = 1
	transform.origin.z = y * 2
	rotation.y = rotate90 * direction


func moveForwardBackward(moveDirection : int) -> void:
	if moveDirection == direction: # foward
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
	
	elif moveDirection == (direction + 2) % 4: # backward
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


func input() -> void:
	var foward = Input.is_action_pressed("ui_up")
	var backward = Input.is_action_pressed("ui_down")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	
	if !$tween.is_active():
		if foward:
			if !freeFlight:
				Signals.emit_signal("playerMoved", direction)
			else:
				moveForwardBackward(direction)
		
		if backward:
			if !freeFlight:
				Signals.emit_signal("playerMoved", (direction + 2) % 4)
			else:
				moveForwardBackward((direction + 2) % 4)
		
		if left:
			self.direction -= 1
			$tween.interpolate_property(
				self,
				"rotation:y",
				rotation.y,
				rotation.y + rotate90,
				0.25
			)
			$tween.start()
		
		if right:
			self.direction += 1
			$tween.interpolate_property(
				self,
				"rotation:y",
				rotation.y,
				rotation.y - rotate90,
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
				self,
				"rotation:x",
				rotation.x,
				rotation.x + (rotate45 if rotation.x <= rotate45 else 0),
				0.25
			)
			$tween.start()
		
		if pitchDown:
			$tween.interpolate_property(
				self,
				"rotation:x",
				rotation.x,
				rotation.x - (rotate45 if rotation.x > -rotate90 else 0),
				0.25
			)
			$tween.start()

