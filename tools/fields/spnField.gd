extends SpinBox

@export
var parameter : String
var dto : DTO :
	set(newValue):
		dto = newValue
		value = dto[parameter]


func _ready() -> void:
	value_changed.connect(func(value): dto[parameter] = value)

