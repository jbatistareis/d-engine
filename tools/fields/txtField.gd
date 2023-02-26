extends LineEdit

@export
var parameter : String
var dto : DTO :
	set(value):
		dto = value
		text = dto[parameter]
		editable = (dto != null)

func _ready() -> void:
	text_changed.connect(func(value): dto[parameter] = value)

