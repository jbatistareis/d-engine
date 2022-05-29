extends GridContainer

var cellScene : PackedScene = preload("res://tools/location/cell.tscn")


func _ready() -> void:
	for i in range(columns * columns):
		var cell = cellScene.instance()
		cell.room.id = i
		cell.room.x = i % columns
		cell.room.y = i / columns
		
		add_child(cell)

