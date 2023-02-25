extends HBoxContainer

const _SAVE_TXT : String = "Do you wish to save the current values to the '%s' file?"
const _DELETE_TXT : String = "Do you wish to delete the '%s' file?"

var dto : DTO :
	set(value):
		dto = value
		$btnSave.disabled = (value == null)
		$btnDelete.disabled = $btnSave.disabled
var reloadFunc : Callable = Callable()


func _ready() -> void:
	$btnReload.pressed.connect(func(): reloadFunc.call())
	$btnSave.pressed.connect(func():
		$dlgSave.dialog_text = _SAVE_TXT % dto.shortName
		$dlgSave.popup_centered())
	$btnDelete.pressed.connect(func():
		$dlgDelete.dialog_text = _DELETE_TXT % dto.shortName
		$dlgDelete.popup_centered())
	
	$dlgSave.confirmed.connect(func(): Persistence.saveDTO(dto))
	$dlgDelete.confirmed.connect(func(): Persistence.deleteDTO(dto))

