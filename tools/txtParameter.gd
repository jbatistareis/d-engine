extends LineEdit

var dto : DTO = DTO.new()
@export
var parameter : String


func _on_text_changed(new_text: String) -> void:
	dto[parameter] = new_text

