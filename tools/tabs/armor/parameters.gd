extends BaseParameters


func setDto(value : ArmorDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortName.dto = value
	$scalingGrid/spnPositive.dto = value
	$scalingGrid/spnNegative.dto = value
	$integGrid/spnCurrent.dto = value
	$integGrid/spnMaximum.dto = value

