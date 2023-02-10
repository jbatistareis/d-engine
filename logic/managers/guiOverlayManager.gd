extends Node

var windowQueue : Array = []

@onready var oldSize : Vector2 = get_viewport().size
@onready var currentSize : Vector2 = get_viewport().size
var ratioDiff : float = 1.0


func _ready() -> void:
	get_viewport().connect("size_changed",Callable(self,"changeSize"))


func changeSize() -> void:
	oldSize = currentSize
	currentSize = get_viewport().size
	
	ratioDiff = currentSize.x / oldSize.x

