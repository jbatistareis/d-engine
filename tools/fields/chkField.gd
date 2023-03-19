extends CheckBox

@export
var property : String
var dto : DTO :
	set(value):
		dto = value
		button_pressed = dto[property]
		disabled = (dto == null)


func _ready() -> void:
	toggled.connect(func(value): dto[property] = value)

