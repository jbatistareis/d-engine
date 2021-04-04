extends GridContainer

const SIZE : int = 32
const TOTAL_TILES : int = SIZE * SIZE

var roomItemScene : PackedScene = preload("res://tools/location/rooms/roomItem.tscn")


func _ready():
	LocationEditorSignals.connect("loadedLocation", self, "distributeRooms")
	
	for i in TOTAL_TILES:
		var roomItem = roomItemScene.instance()
		roomItem.setCoordinate(i % SIZE, i / SIZE)
		
		add_child(roomItem)


func distributeRooms(location : Location) -> void:
	for room in location.rooms:
		get_child(room.x + room.y * SIZE).room = room


func collectRooms() -> Array:
	var rooms = []
	for roomItem in get_children():
		if roomItem.room != null:
			connectRoom(roomItem.room)
			rooms.append(roomItem.room)
	return rooms


func connectRoom(room : Room) -> void:
	var index
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


func setConnections(room : Room, directions : Array) -> void:
	var index
	for direction in directions:
		match room.orientation:
			Enums.Direction.NORTH:
				index = room.x + (room.y - 1) * SIZE
				
			Enums.Direction.EAST:
				index = (room.x + 1) + room.y * SIZE
				
			Enums.Direction.SOUTH:
				index = room.x + (room.y + 1) * SIZE
				
			Enums.Direction.WEST:
				index = (room.x - 1) + room.y * SIZE
		
		if ((index >= 0) && (index < TOTAL_TILES)) && get_child(index).room != null:
			room.exits[direction] = get_child(index).room.id
		else:
			room.exits[direction] = 0
	
	for i in 5:
		if !directions.has(i):
			room.exits[i] = 0
			room.portals[i] = 0

