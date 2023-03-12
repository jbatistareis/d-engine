extends MarginContainer

const _90_ROTATION : float = PI / 2
const _TOOLTIP : String = "id: %4d\nx: %2d, y: %2d"

var room : Dictionary = DefaultValues.roomBase.duplicate(true)


func _ready() -> void:
	mouse_entered.connect(_mouseEntered)
	gui_input.connect(_mouseMove)
	
	ToolSignals.selectedRooms.connect(func(rooms): $overlay.visible = rooms.has(room))
	ToolSignals.roomSet.connect(_roomSet)
	
	tooltip_text = _TOOLTIP % [room.id, room.x, room.y]


func _roomSet(roomSet) -> void:
	if roomSet != room:
		return
	
	$icon.frame = room.type
	$lblDirection.visible = (room.type != Enums.RoomType.DUMMY)
	rotation = _90_ROTATION * room.orientation


func _mouseEntered() -> void:
	ToolSignals.hoveredRoom.emit(room)


func _mouseMove(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		ToolSignals.hoveredRoom.emit(room)

