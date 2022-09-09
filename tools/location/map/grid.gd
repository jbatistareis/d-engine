extends GridContainer

signal selectedRoom(room)
signal selectedMultiRoom(rooms)
signal altSelectionActive()

var cellScene : PackedScene = preload("res://tools/location/map/cell.tscn")
var totalRooms : int

var multiRooms : Array = []

var checkSelection : bool = false
var mousePressed : bool
var mouseDragged : bool
var selection : Dictionary = { 'start': Vector2.ZERO, 'end': Vector2.ZERO }

var altSelectionMode : bool = false
var altSelection : Array = []

onready var btnAutotile : Button = get_node("../../../../parameters/Room/mainContainer/model/controls/VBoxContainer/HBoxContainer/btnAutotile")
onready var btnDelete : Button = get_node("../../../../parameters/Room/mainContainer/model/controls/VBoxContainer/HBoxContainer/btnDelete")
onready var scroll : ScrollContainer = get_node("../..")
onready var selectionArea : Area2D = get_node("../selectionArea")


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
		altSelectionMode = mousePressed && (event.button_index == 2)
		
		if !mousePressed && mouseDragged:
			mouseDragged = false
		
	elif mousePressed && (event is InputEventMouseMotion):
		mouseDragged = true
		
		selectionArea.global_position = event.position #+ Vector2(scroll.scroll_horizontal, scroll.scroll_vertical)
		
		if !multiRooms.empty():
			emit_signal("selectedMultiRoom", multiRooms)


func clearAltSelection() -> void:
	for item in altSelection:
		get_child(item.id).select(false, false)
	
	altSelection.clear()
	btnAutotile.disabled = true
	btnDelete.disabled = true


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
#		cell.room = {}
		pass
	
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
	
	for i in 4:
		if !directions.has(i):
			room.exits[i] = -1


func _on_selectionArea_body_entered(body):
	if !altSelectionMode:
		if mouseDragged && ("room" in body.get_parent()) && !body.get_parent().room.empty():
			for room in multiRooms:
				if room.id == body.get_parent().room.id:
					return
			
			multiRooms.append(body.get_parent().room)
	else:
		multiRooms.clear()
		emit_signal("altSelectionActive")
		
		body.get_parent().select(true, true)
		altSelection.append({ 
			'id': body.get_parent().id,
			'x': body.get_parent().x,
			'y': body.get_parent().y
		})
		
		btnAutotile.disabled = false
		btnDelete.disabled = false



func _on_grid_selectedRoom(room):
	altSelectionMode = false
	multiRooms = [room]
	emit_signal("selectedMultiRoom", multiRooms)
