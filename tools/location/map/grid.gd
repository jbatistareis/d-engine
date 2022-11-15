extends GridContainer

var cellScene : PackedScene = preload("res://tools/location/map/cell.tscn")
var totalRooms : int

var multiRooms : Array = []

var mousePressed : bool
var mouseDragged : bool

onready var scroll : ScrollContainer = get_node("../..")
onready var selectionArea : Area2D = get_node("../selectionArea")


func _ready() -> void:
	totalRooms = columns * columns
	
	for i in range(totalRooms):
		var cell = cellScene.instance()
		cell.id = i
		cell.x = i % columns
		cell.y = i / columns
		cell.room = DefaultValues.roomBase
		
		add_child(cell)
	
	EditorSignals.connect("mapSelectedRoom", self, "clearMultiSelection")


func _input(event) -> void:
	if event is InputEventMouseButton:
		mousePressed = event.pressed && (event.button_index == 2)
		
		if !mousePressed && mouseDragged:
			mouseDragged = false
		
	elif mousePressed && (event is InputEventMouseMotion):
		mouseDragged = true
		
		selectionArea.global_position = event.position #+ Vector2(scroll.scroll_horizontal, scroll.scroll_vertical)
		
		if !multiRooms.empty():
			EditorSignals.emit_signal("mapSelectedMultiRooms", multiRooms)


func clearMultiSelection(ignore) -> void:
	for item in multiRooms:
		get_child(item.id).select(false)
	
	multiRooms.clear()


func collectRooms() -> Array:
	var rooms = []
	
	for cell in get_children():
		if cell.room.type != Enums.RoomType.DUMMY:
			connectRoom(cell.room)
			
			for idx in range(cell.room.foeShortNameGroups.size()):
				if cell.room.foeShortNameGroups[idx].empty() || (cell.room.foeShortNameGroups[idx][0].empty()):
					cell.room.foeShortNameGroups.remove(idx)
			
			rooms.append(cell.room)
	
	return rooms


func loadRooms(rooms : Array) -> void:
	for room in rooms:
		get_child(room.id).room = room


func connectRoom(room : Dictionary) -> void:
	match room.type:
		Enums.RoomType._2_EXITS_I:
			if (room.orientation == Enums.Direction.NORTH) || (room.orientation == Enums.Direction.SOUTH):
				setConnections(room, [Enums.Direction.NORTH, Enums.Direction.SOUTH])
			
			elif (room.orientation == Enums.Direction.EAST) || (room.orientation == Enums.Direction.WEST):
				setConnections(room, [Enums.Direction.EAST, Enums.Direction.WEST])
		
		Enums.RoomType._2_EXITS_L:
			match room.orientation:
				Enums.Direction.NORTH:
					setConnections(room, [Enums.Direction.NORTH, Enums.Direction.EAST])
				
				Enums.Direction.EAST:
					setConnections(room, [Enums.Direction.EAST, Enums.Direction.SOUTH])
				
				Enums.Direction.SOUTH:
					setConnections(room, [Enums.Direction.SOUTH, Enums.Direction.WEST])
				
				Enums.Direction.WEST:
					setConnections(room, [Enums.Direction.WEST, Enums.Direction.NORTH])
		
		Enums.RoomType._3_EXITS:
			match room.orientation:
				Enums.Direction.NORTH:
					setConnections(room, [Enums.Direction.WEST, Enums.Direction.NORTH, Enums.Direction.EAST])
				
				Enums.Direction.EAST:
					setConnections(room, [Enums.Direction.NORTH, Enums.Direction.EAST, Enums.Direction.SOUTH])
				
				Enums.Direction.SOUTH:
					setConnections(room, [Enums.Direction.EAST, Enums.Direction.SOUTH, Enums.Direction.WEST])
				
				Enums.Direction.WEST:
					setConnections(room, [Enums.Direction.SOUTH, Enums.Direction.WEST, Enums.Direction.NORTH])
		
		Enums.RoomType._4_EXITS:
			setConnections(room, [Enums.Direction.NORTH, Enums.Direction.EAST, Enums.Direction.SOUTH, Enums.Direction.WEST])
		
		Enums.RoomType._1_EXIT:
			setConnections(room, [room.orientation])
		
		Enums.RoomType._0_EXIT:
			setConnections(room, [])
		_: # DUMMY
			return


func setConnections(room : Dictionary, directions : Array) -> void:
	var index
	for direction in directions:
		match direction:
			Enums.Direction.NORTH:
				index = room.x + (room.y - 1) * columns
				
			Enums.Direction.EAST:
				index = (room.x + 1) + room.y * columns
				
			Enums.Direction.SOUTH:
				index = room.x + (room.y + 1) * columns
				
			Enums.Direction.WEST:
				index = (room.x - 1) + room.y * columns
		
		if ((index >= 0) && (index < totalRooms)) && !get_child(index).room.empty() && (get_child(index).room.type != Enums.RoomType.DUMMY):
			room.exits[direction] = get_child(index).room.id
		else:
			room.exits[direction] = -1
	
	for i in 4:
		if !directions.has(i):
			room.exits[i] = -1


func _on_selectionArea_body_entered(body):
	if mousePressed || mouseDragged:
		if "room" in body.get_parent():
			body.get_parent().toggleSelect()
			
			if multiRooms.has(body.get_parent().room):
				multiRooms.erase(body.get_parent().room)
			else:
				multiRooms.append(body.get_parent().room)
			
			if !multiRooms.empty():
				EditorSignals.emit_signal("mapSelectedMultiRooms", multiRooms)

