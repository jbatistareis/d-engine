extends BaseParameters


func _ready() -> void:
	$paramsGrid/optTarget.valuesFunc = func(): return [
		"None",
		"Single any", "Single friendly", "Single foe",
		"Multi any", "Multi friendly", "Multi foe"]
	
	$paramsGrid/optType.valuesFunc = func(): return ["Consumable", "Key"]


func setDto(value : ItemDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$idGrid/txtDescription.dto = value
	$paramsGrid/optTarget.dto = value
	$paramsGrid/optType.dto = value
	$paramsGrid/spnPrice.dto = value
	$cdeAction.dto = value

