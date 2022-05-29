extends ConfirmationDialog


func _enter_tree() -> void:
	get_ok().text = 'Yes'
	get_cancel().text = 'No'
	get_close_button().queue_free()

