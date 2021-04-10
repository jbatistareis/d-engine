extends Container

var x : int = 0
var y : int = 0

var room : Room = null setget setRoom

var selected : bool = false


func _ready():
	deselect()
	
	connect("gui_input", self, "toggleSelect")
	LocationEditorSignals.connect("selectedItem", self, "checkSelect")
	LocationEditorSignals.connect("deselectedItem", self, "checkDeselect")
	
	$buttons.connect("mouse_entered", self, "showButtons")
	$buttons/changeRoom.connect("mouse_entered", self, "showButtons")
	$buttons/rotateRoom.connect("mouse_entered", self, "showButtons")
	
	$buttons.connect("mouse_exited", self, "hideButtons")
	$buttons/changeRoom.connect("mouse_exited", self, "hideButtons")
	$buttons/rotateRoom.connect("mouse_exited", self, "hideButtons")
	
	$buttons/changeRoom.get_popup().connect("index_pressed", self, "setRoomType")
	$buttons/rotateRoom.connect("button_up", self, "increaseOrientation")


func checkSelect(room : Room) -> void:
	if (self.room != null) && (room.id == self.room.id):
		select()


func checkDeselect(room : Room) -> void:
	if (self.room != null) && (room.id == self.room.id):
		deselect()


func deselect() -> void:
	selected = false
	$background/cover.color.b = 0
	$background/cover.color.a = 0.1


func select() -> void:
	selected = true
	$background/cover.color.b = 1
	$background/cover.color.a = 0.5


func showButtons() -> void:
	$buttons.modulate.a = 1


func hideButtons() -> void:
	$buttons.modulate.a = 0


func setRoomType(value : int) -> void:
	if value == 0:
		LocationEditorSignals.emit_signal("deselectedRoom", room)
		
		room = null
		
		$buttons/rotateRoom.disabled = true
		$buttons/rotateRoom.modulate.a = 0
		
	else:
		if room == null:
			self.room = Room.new()
			room.id = EditorIdGenerator.id
			room.x = x
			room.y = y
		room.type = value - 1
		room.mesh = room.type
		
		LocationEditorSignals.emit_signal("selectedRoom", room, true)
		
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
	
	$background/roomIcon.frame = value


func toggleSelect(event : InputEvent) -> void:
	if (room != null):
		var left = event.is_action_pressed("left_click")
		var right = event.is_action_pressed("right_click")
		
		if left || right:
			
			if left:
				LocationEditorSignals.emit_signal("selectedRoom", room, true)
			else:
				selected = !selected
				
				if selected:
					LocationEditorSignals.emit_signal("selectedRoom", room, false)
				else:
					LocationEditorSignals.emit_signal("deselectedRoom", room)


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
	
	LocationEditorSignals.emit_signal("selectedRoom", room, true)


func setRoom(value : Room) -> void:
	room = value
	
	if value != null:
		$buttons/rotateRoom.disabled = false
		$buttons/rotateRoom.modulate.a = 1
		
		$background/roomIcon.frame = room.type + 1
		$background/roomIcon.rotation = PI / 2 * room.orientation

