extends ConfirmationDialog


func _ready() -> void:
	get_ok_button().text = 'Yes'
	get_cancel_button().text = 'No'

