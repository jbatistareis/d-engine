extends GridContainer

signal selectedRoom(room)
signal selectedMultiRoom(rooms)

var cellScene : PackedScene = preload("res://tools/location/map/cell.tscn")
var totalRooms : int

var checkSelection : bool = false
var mousePressed : bool
var mouseDragged : bool
var selection : Dictionary = { 'start': Vector2.ZERO, 'end': Vector2.ZERO }


func _ready() -> void:
	totalRooms = columns * columns
	
	for i in range(totalRooms):
		var cell = cellScene.instance()
		cell.id = i
		cell.x = i % columns
		cell.y = i / columns
		
		add_child(cell)


func _input(event) -> void:
	if event is InputEventMouseButton:
		mousePressed = event.pressed
		
		if mousePressed:
			selection.start = event.position
		elif !mousePressed && mouseDragged:
			mouseDragged = false
			selection.end = event.position
			
			var selectedRooms = []
			for body in get_node("../../cellSelection/selectionArea").get_overlapping_bodies():
				if !body.get_parent().room.empty():
					selectedRooms.append(body.get_parent().room)
			
			if !selectedRooms.empty():
				emit_signal("selectedMultiRoom", selectedRooms)
			
	elif mousePressed && (event is InputEventMouseMotion):
		mouseDragged = true
		selection.end = event.position
		
		var start = Vector2.ZERO
		var end = Vector2.ZERO
		var pivot = Vector2.ZERO
		
		if selection.start.x < selection.end.x:
			start = selection.start
			end = selection.end
			
			if selection.start.y < selection.end.y:
				pivot = selection.start
			else:
				start.y = selection.end.y
				end.y = selection.start.y
				pivot = start
		else:
			if selection.start.y < selection.end.y:
				start.x = selection.end.x
				start.y = selection.start.y
				end.x = selection.start.x
				end.y = selection.end.y
				pivot = start
			else:
				start = selection.end
				end = selection.start
				pivot = selection.end
		
		get_node("../../cellSelection").rect_position = pivot
		get_node("../../cellSelection").rect_size = end - start
		get_node("../../cellSelection").color = Color(1, 1, 1, 0.5)
		get_node("../../cellSelection/selectionArea/collision").shape.extents = (end - start) / 2.0
		get_node("../../cellSelection/selectionArea").global_position = start + ((end - start) / 2.0)


func collectRooms() -> Array:
	var rooms = []
	
	for cell in get_children():
		if !cell.room.empty():
			connectRoom(cell.room)
			
			for idx in range(cell.room.foeShortNameGroups.size()):
				if cell.room.foeShortNameGroups[idx].empty() || (cell.room.foeShortNameGroups[idx][0].empty()):
					cell.room.foeShortNameGroups.remove(idx)
			
			rooms.append(cell.room)
	
	return rooms


func loadRooms(rooms : Array) -> void:
	for cell in get_children():
		cell.room = {}
	
	for room in rooms:
		get_child(room.id).room = room


func connectRoom(room : Dictionary) -> void:
	match room.type:
		Enums.RoomType._1_EXIT:
			setConnections(room, [room.orientation])
		
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
		
		_: # _0_EXITS
			setConnections(room, [])


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
	
	for i in 5:
		if !directions.has(i):
			room.exits[i] = -1



func _on_grid_selectedRoom(room):
	get_node("../../cellSelection").color = Color.transparent
