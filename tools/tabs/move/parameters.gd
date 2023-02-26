extends BaseParameters


func setDto(value : MoveDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value

