extends GridMap

# for gridmap rotations, i added a cell with each orientation via the editor, and then printed their orientation
var rotations : Array = [0, 22, 10, 16]
var file = File.new()


func _ready() -> void:
	Signals.connect("playerSpawned", self, "loadMap")
	LocationEditorSignals.connect("testLocation", self, "loadMap")


func loadMap(location : Location, x : int, y : int, direction : int) -> void:
	clear()
	
	var path = GamePaths.LOCATION_MESH_LIB_DATA % location.shortName
	if file.file_exists(path):
		mesh_library = load(path)
	
	# TODO find out why the 1st mesh is 'Cube'
	for room in location.rooms:
		set_cell_item(room.x, 0, room.y, room.mesh + 1, rotations[room.orientation])

