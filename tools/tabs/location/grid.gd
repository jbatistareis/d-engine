extends GridContainer

var totalRooms : int


func collectRooms() -> Array:
	totalRooms = get_child_count()
	var rooms = []
	
	for cell in get_children():
		if cell.room.type != Enums.RoomType.DUMMY:
			connectRoom(cell.room)
			
			for idx in range(cell.room.foeShortNameGroups.size()):
				if cell.room.foeShortNameGroups[idx].is_empty() || (cell.room.foeShortNameGroups[idx][0].is_empty()):
					cell.room.foeShortNameGroups.remove_at(idx)
			
			rooms.append(cell.room)
	
	return rooms


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
		
		if ((index >= 0) && (index < totalRooms)) && !get_child(index).room.is_empty() && (get_child(index).room.type != Enums.RoomType.DUMMY):
			room.exits[direction] = get_child(index).room.id
		else:
			room.exits[direction] = -1
	
	for i in 4:
		if !directions.has(i):
			room.exits[i] = -1

