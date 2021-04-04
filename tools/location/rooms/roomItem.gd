extends Container

var x : int = 0
var y : int = 0

var room : Room = null setget setRoom


func _ready():
	deselect(null)
	
	connect("gui_input", self, "openProperties")
	
	LocationEditorSignals.connect("selectedRoom", self, "deselect")
	
	$buttons.connect("mouse_entered", self, "showButtons")
	$buttons/changeRoom.connect("mouse_entered", self, "showButtons")
	$buttons/rotateRoom.connect("mouse_entered", self, "showButtons")
	
	$buttons.connect("mouse_exited", self, "hideButtons")
	$buttons/changeRoom.connect("mouse_exited", self, "hideButtons")
	$buttons/rotateRoom.connect("mouse_exited", self, "hideButtons")
	
	$buttons/changeRoom.get_popup().connect("index_pressed", self, "setRoomType")
	$buttons/rotateRoom.connect("button_up", self, "increaseOrientation")


func deselect(room : Room) -> void:
	$background/cover.color.b = 0
	$background/cover.color.a = 0.1


func select() -> void:
	LocationEditorSignals.emit_signal("selectedRoom", room)
	$background/cover.color.b = 1
	$background/cover.color.a = 0.5


func showButtons() -> void:
	$buttons.modulate.a = 1


func hideButtons() -> void:
	$buttons.modulate.a = 0


func setRoomType(value : int) -> void:
	if value == 0:
		room = null
		
		$buttons/rotateRoom.disabled = true
		$buttons/rotateRoom.modulate.a = 0
		
		deselect(null)
		LocationEditorSignals.emit_signal("selectedRoom", null)
	else:
		if room == null:
			self.room = Room.new()
			self.room.id = EditorIdGenerator.id
			self.room.x = x
			self.room.y = y
		room.type = value - 1
		room.mesh = room.type
		
		select()
		
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
	
	$background/roomIcon.frame = value


func openProperties(event : InputEvent) -> void:
	if (room != null) && event.is_action_pressed("left_click"):
		select()


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
	
	select()


func setRoom(value : Room) -> void:
	room = value
	
	if value != null:
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
		
		$background/roomIcon.frame = room.type + 1
		$background/roomIcon.rotate(PI / 2 * room.orientation)

