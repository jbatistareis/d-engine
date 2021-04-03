extends Camera

var freeFlight : bool = false

var cameraMoventSpeed : float = 15
var cameraRotationSpeed : float = 200
var cameraElevationSpeed : float = 15
var cameraPitchSpeed : float = 50


func _ready() -> void:
	LocationEditorSignals.connect("testLocation", self, "setFreeFlight")


func _process(delta : float) -> void:
	if freeFlight:
		freeFlightMove(delta)


func setFreeFlight(ignore) -> void:
	transform.origin.x = 32.0
	transform.origin.y = 8.0
	transform.origin.z = 64.0
	
	freeFlight = true


func freeFlightMove(delta : float) -> void:
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var foward = Input.is_action_pressed("ui_up")
	var backward = Input.is_action_pressed("ui_down")
	var elevationUp = Input.is_action_pressed("ui_page_up")
	var elevationDown = Input.is_action_pressed("ui_page_down")
	var pitchUp = Input.is_action_pressed("ui_home")
	var pitchDown = Input.is_action_pressed("ui_end")
	
	if left:
		rotation_degrees.y += cameraRotationSpeed * delta
	
	if right:
		rotation_degrees.y -= cameraRotationSpeed * delta
	
	if foward:
		transform.origin -= Vector3(
			sin(rotation.y) * cameraMoventSpeed * delta,
			0,
			cos(rotation.y) * cameraMoventSpeed * delta
		)
	
	if backward:
		transform.origin += Vector3(
			sin(rotation.y) * cameraMoventSpeed * delta,
			0,
			cos(rotation.y) * cameraMoventSpeed * delta
		)
	
	if elevationUp:
		translate(Vector3(0, cameraElevationSpeed * delta, 0))
	
	if elevationDown:
		translate(-Vector3(0, cameraElevationSpeed * delta, 0))
	
	if pitchUp:
		rotation_degrees.x += cameraRotationSpeed * delta
	
	if pitchDown:
		rotation_degrees.x -= cameraRotationSpeed * delta

