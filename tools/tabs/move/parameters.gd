extends BaseParameters

const _PREVIEW_MASK : String = "(%0.2fs)"


func _ready() -> void:
	$idGrid/optTarget.valuesFunc = func(): return [
		"None",
		"Single any", "Single friendly", "Single foe",
		"Multi any", "Multi friendly", "Multi foe"]


func setDto(value : MoveDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$idGrid/txtDescription.dto = value
	$idGrid/optTarget.dto = value
	$cdGrid/spnPre.dto = value
	$cdGrid/spnPost.dto = value
	$animGrid/txtPrepare.dto = value
	$animGrid/txtAttack.dto = value
	$mods/scaling/spnScale.dto = value
	$mods/grid/spnAtkExc.dto = value
	$mods/grid/spnDefExc.dto = value
	$mods/grid/spnCdExc.dto = value
	$mods/grid/spnAtkTgt.dto = value
	$mods/grid/spnDefTgt.dto = value
	$mods/grid/spnCdTgt.dto = value
	
	_on_spn_pre_value_changed(value.cdPre)
	_on_spn_post_value_changed(value.cdPos)
	
	await get_tree().process_frame
	ToolSignals.loadedMove.emit(value)


func _getCdPreview(cd : int) -> String:
	return _PREVIEW_MASK % (1000.0 * GameParameters.GCD * cd / 1000.0)


func _on_spn_pre_value_changed(value: float) -> void:
	$cdGrid/lblPrePreview.text = _getCdPreview(value)


func _on_spn_post_value_changed(value: float) -> void:
	$cdGrid/lblPostPreview.text = _getCdPreview(value)

