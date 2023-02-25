extends SpinBox

@export
var parameter : String
var dto : DTO :
	set(newValue):
		dto = newValue
		value = dto[parameter]


func _on_value_changed(value: float) -> void:
	dto[parameter] = value

