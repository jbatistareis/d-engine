extends HBoxContainer

const _SAVE_TXT : String = "Do you wish to save the current values to the '%s' file?"
const _DELETE_TXT : String = "Do you wish to delete the '%s' file?"

var dto : DTO = null
var reloadFunc : Callable = Callable()


func _ready() -> void:
	$btnReload.pressed.connect(func(): reloadFunc.call())
	$btnSave.pressed.connect(func():
		$dlgSave.dialog_text = _SAVE_TXT % dto.shortName
		$dlgSave.popup_centered())
	$btnDelete.pressed.connect(func():
		$dlgDelete.dialog_text = _DELETE_TXT % dto.shortName
		$dlgDelete.popup_centered())
	
	$dlgSave.confirmed.connect(func():
		Persistence.saveDTO(dto)
		reloadFunc.call())
	$dlgDelete.confirmed.connect(func():
		Persistence.deleteDTO(dto)
		reloadFunc.call())
	
	$timer.timeout.connect(func():
		$btnSave.disabled = (dto == null) || (dto.shortName == null) || dto.shortName.is_empty()
		$btnDelete.disabled = $btnSave.disabled)

