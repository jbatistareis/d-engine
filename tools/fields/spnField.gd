extends SpinBox

@export
var parameter : String
var dto : DTO :
	set(newValue):
		dto = newValue
		value = dto[parameter]
		editable = (dto != null)


func _ready() -> void:
	value_changed.connect(func(newValue): dto[parameter] = newValue)

