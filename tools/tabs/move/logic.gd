extends BaseParameters


func _ready() -> void:
	ToolSignals.loadedMove.connect(setDto)


func setDto(value : MoveDTO) -> void:
	$tabs/Value/cdeValue.dto = value
	$tabs/Outcome/cdeOutcome.dto = value
	$tabs/Pick/cdePick.dto = value
	$tabs/Execute/cdeExecute.dto = value

