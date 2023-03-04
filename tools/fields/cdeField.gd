extends CodeEdit

@export
var property : String
var dto : DTO :
	set(value):
		dto = value
		text = dto[property]
		editable = (dto != null)


func _ready() -> void:
	text_changed.connect(func(): dto[property] = text)

