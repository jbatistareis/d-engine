extends GridContainer

var cellScene : PackedScene = preload("res://tools/location/map/cell.tscn")


func _ready() -> void:
	for i in range(columns * columns):
		var cell = cellScene.instance()
		cell.id = i
		cell.x = i % columns
		cell.y = i / columns
		
		add_child(cell)


func collectRooms() -> Array:
	var rooms = []
	
	for cell in get_children():
		if !cell.room.empty():
			rooms.append(cell.room)
	
	return rooms


func loadRooms(rooms : Array) -> void:
	for cell in get_children():
		cell.room = {}
	
	for room in rooms:
		get_child(room.id).room = room

