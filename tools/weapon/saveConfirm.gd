extends ConfirmationDialog

const _MESSAGE : String = 'Do you wish to save/overwrite the file \'%s\'?'

var entityName : String setget setEntityName


func _ready() -> void:
	get_ok().text = 'Yes'
	get_cancel().text = 'No'


func setEntityName(value : String) -> void:
	dialog_text = _MESSAGE % value

