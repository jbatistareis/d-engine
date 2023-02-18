extends ConfirmationDialog

const _MESSAGE : String = 'Do you wish to save/overwrite the file \'%s\'?'

var entityName : String : set = setEntityName


func _ready() -> void:
	get_ok_button().text = 'Yes'
	get_cancel_button().text = 'No'


func setEntityName(value : String) -> void:
	dialog_text = _MESSAGE % value

