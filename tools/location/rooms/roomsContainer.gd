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
			rooms.append(roomItem.room)
	return rooms

