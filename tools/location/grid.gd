extends GridContainer

signal selectedTile(gridItem)

const SIZE : int = 32
const TOTAL_TILES : int = SIZE * SIZE

var gridItemScene : PackedScene = preload("res://tools/location/gridItem.tscn")


func _ready():
	connect("selectedTile", self, "editRoom")
	
	for i in TOTAL_TILES:
		var gridItem = gridItemScene.instance()
		gridItem.setCoordinate(i % SIZE, i / SIZE)
		
		add_child(gridItem)


func editRoom(gridItem : Control) -> void:
	print(str(gridItem.x) + ', ' + str(gridItem.y))

