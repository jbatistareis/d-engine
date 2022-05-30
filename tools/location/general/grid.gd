extends GridContainer

var cellScene : PackedScene = preload("res://tools/location/general/cell.tscn")


func _ready() -> void:
	var dummyRoom = GameParameters.roomBase
	dummyRoom.type = Enums.RoomType.DUMMY
	dummyRoom.model = ''
	
	for i in range(columns * columns):
		dummyRoom.id = i
		dummyRoom.x = i % columns
		dummyRoom.y = i / columns
		
		var cell = cellScene.instance()
		cell.room = dummyRoom
		
		add_child(cell)


func resetRooms() -> void:
	var i = 0
	var dummyRoom = GameParameters.roomBase
	dummyRoom.type = Enums.RoomType.DUMMY
	dummyRoom.model = ''
	
	for cell in get_children():
		dummyRoom.id = i
		dummyRoom.x = i % columns
		dummyRoom.y = i / columns
		
		cell.room = dummyRoom
		i += 1


func loadRooms(rooms : Array) -> void:
	resetRooms()
	
	for room in rooms:
		get_child(room.id).room = room

