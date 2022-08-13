extends ConfirmationDialog


func _ready() -> void:
	get_ok().text = 'Yes'
	get_cancel().text = 'No'

