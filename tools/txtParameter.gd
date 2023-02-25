extends LineEdit

@export
var parameter : String
var dto : DTO :
	set(value):
		dto = value
		text = dto[parameter]


func _on_text_changed(new_text: String) -> void:
	dto[parameter] = new_text

