extends ColorRect

const _ROTATION : float = PI / 2
const _BASE_MODELS : Array = ['', '0_exits', '1_exit', '2_exits_I', '2_exits_L', '3_exits', '4_exits']
const _HINT_TEXT : String = 'id: %d\nx: %d, y: %d'

var id : int
var x : int
var y : int
var room : Dictionary = {} setget setRoom


func _ready() -> void:
	updateHint()
	
	$options.get_popup().connect("mouse_exited", self, "closeMenu")
	$options.get_popup().add_multistate_item("Rotate R", 1)
	$options.get_popup().add_multistate_item("Rotate L", 1)
	$options.get_popup().add_separator()
	$options.get_popup().add_multistate_item("None", 1)
	$options.get_popup().add_multistate_item("0 Exits", 1)
	$options.get_popup().add_multistate_item("1 Exit", 1)
	$options.get_popup().add_multistate_item("2 Exits I", 1)
	$options.get_popup().add_multistate_item("2 Exits L", 1)
	$options.get_popup().add_multistate_item("3 Exits", 1)
	$options.get_popup().add_multistate_item("4 Exits", 1)
	$options.get_popup().connect("index_pressed", self, "optionSelected")


func optionSelected(index : int) -> void:
	if !room.empty() && (index == 0):
		$icon.rotate(_ROTATION)
		var newOrientation = room.orientation + 1
		room.orientation = newOrientation if (newOrientation <= Enums.Direction.WEST) else 0
	
	elif !room.empty() && (index == 1):
		$icon.rotate(-_ROTATION)
		var newOrientation = room.orientation - 1
		room.orientation = newOrientation if (newOrientation >= Enums.Direction.NORTH) else 3
	
	elif index >= 3:
		if room.empty():
			self.room = DefaultValues.roomBase
			room.id = id
			room.x = x
			room.y = y
		
		index -= 3
		$icon.frame = index
		
		if index > 0:
			room.type = index
			room.model = _BASE_MODELS[index]
		else:
			room.clear()
			select(false, false)
	
	updateHint()
	
	if !room.empty():
		get_parent().emit_signal("selectedRoom", room)


func updateHint() -> void:
	$options.hint_tooltip = _HINT_TEXT % [id, x, y]
	$icon/pointer.visible = !room.empty() && (room.type != Enums.RoomType.DUMMY)


func setRoom(value : Dictionary) -> void:
	room = value.duplicate(true)
	
	if !room.empty():
		$icon.frame = room.type
		$icon.rotation = _ROTATION * room.orientation
	else:
		$icon.frame = Enums.RoomType.DUMMY
		$icon.rotation = 0
	
	updateHint()


func closeMenu() -> void:
	$options.get_popup().hide()


func select(value : bool, bitmask : bool) -> void:
	if !bitmask:
		color.b = 0.8 if value else 0
		color.r = 0
	else:
		color.b = 0
		color.r = 0.8 if value else 0
	
	color.a = 0.4 if value else 0.15


func _on_options_pressed():
	get_parent().emit_signal("selectedRoom", room)
	get_parent().clearBitmask()

