extends SpinBox

@export
var property : String
var dto : DTO :
	set(newValue):
		dto = newValue
		value = dto[property]
		editable = (dto != null)


func _ready() -> void:
	value_changed.connect(func(newValue): dto[property] = newValue)

