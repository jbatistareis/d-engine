extends GridContainer

var cellScene : PackedScene = preload("res://tools/location/general/cell.tscn")


func _ready() -> void:
	for i in range(columns * columns):
		var cell = cellScene.instance()
		cell.roomDict.id = i + 1
		cell.roomDict.x = i % columns
		cell.roomDict.y = i / columns
		
		add_child(cell)


func loadRooms(roomDicts : Array) -> void:
	for roomDict in roomDicts:
		get_child(roomDict.id).roomDict = roomDict

