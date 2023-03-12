extends GridContainer


func collectRooms() -> Array:
	var result = []
	
	for child in get_children():
		if child.room.type != Enums.RoomType.DUMMY:
			result.append(child.room)
	
	return result

