extends Container

var x : int = 0
var y : int = 0

var room : Room = null setget setRoom


func _ready():
	connect("gui_input", self, "openProperties")
	
	$buttons.connect("mouse_entered", self, "showButtons")
	$buttons/changeRoom.connect("mouse_entered", self, "showButtons")
	$buttons/rotateRoom.connect("mouse_entered", self, "showButtons")
	
	$buttons.connect("mouse_exited", self, "hideButtons")
	$buttons/changeRoom.connect("mouse_exited", self, "hideButtons")
	$buttons/rotateRoom.connect("mouse_exited", self, "hideButtons")
	
	$buttons/changeRoom.get_popup().connect("index_pressed", self, "setRoomType")
	$buttons/rotateRoom.connect("button_down", self, "increaseOrientation")


func showButtons() -> void:
	$buttons.modulate.a = 1


func hideButtons() -> void:
	$buttons.modulate.a = 0


func setRoomType(value : int) -> void:
	if value == 0:
		room = null
		
		$buttons/rotateRoom.disabled = true
		$buttons/rotateRoom.modulate.a = 0
	else:
		if room == null:
			self.room = Room.new()
			self.room.id = EditorIdGenerator.id
		room.type = value
		LocationEditorSignals.emit_signal("selectedRoom", room)
		
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
	
	$background/roomIcon.frame = value


func openProperties(event : InputEvent) -> void:
	if (room != null) && event.is_action_pressed("left_click"):
		LocationEditorSignals.emit_signal("selectedRoom", room)


func setCoordinate(x : int, y : int) -> void:
	self.x = x
	self.y = y
	
	if room != null :
		room.x = x
		room.y = y
	
	hint_tooltip = str(x) + ', ' + str(y)


func increaseOrientation() -> void:
	room.orientation += 1
	$background/roomIcon.rotate(PI / 2)
	
	LocationEditorSignals.emit_signal("selectedRoom", room)


func setRoom(value : Room) -> void:
	room = value
	
	if value != null:
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
		
		$background/roomIcon.frame = room.type
		$background/roomIcon.rotate(PI / 2 * room.orientation)

