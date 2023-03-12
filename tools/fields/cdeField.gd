extends CodeEdit

@export
var property : String

var dto : DTO = null :
	set(value):
		dto = value
		text = dto[property]
		editable = (dto != null)

var multiDto : Array = [] :
	set(value):
		multiDto = value
		text = multiDto[0][property] if !multiDto.is_empty() else ""
		editable = !multiDto.is_empty()


func _ready() -> void:
	text_changed.connect(
		func():
			if dto != null:
				dto[property] = text
			else:
				for dto in multiDto:
					dto[property] = text)

