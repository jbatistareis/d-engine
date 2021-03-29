extends GridContainer

const SIZE : int = 32
const TOTAL_TILES : int = SIZE * SIZE

var gridItemScene : PackedScene = preload("res://tools/location/gridItem.tscn")

func _ready():
	for i in TOTAL_TILES:
		var gridItem = gridItemScene.instance()
		gridItem.setCoordinate(i % SIZE, i / SIZE)
		
		add_child(gridItem)


func distributeRooms(location : Location) -> void:
	for room in location.rooms:
		get_child(room.x + room.y * SIZE).room = room


func collectRooms(location : Location) -> void:
	var id = 0
	
	for gridItem in get_children():
		if gridItem.room != null:
			gridItem.room.id = id
			id += 1
	
	for gridItem in get_children():
		if gridItem.room != null:
			pass

