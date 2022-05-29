extends GridContainer


func _ready() -> void:
	add_child(get_child(0).duplicate())

