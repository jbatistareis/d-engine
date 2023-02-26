extends BaseParameters

const _PREVIEW_MASK : String = "(%0.2fs)"


func _ready() -> void:
	$idGrid/optTarget.valuesFunc = func(): return ["None", "Single any", "Single friendly", "Single foe", "Multi any", "Multi friendly", "Multi foe"]


func setDto(value : MoveDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$idGrid/txtDescription.dto = value
	$idGrid/optTarget.dto = value
	$cdGrid/spnPre.dto = value
	$cdGrid/spnPost.dto = value
	$animGrid/txtPrepare.dto = value
	$animGrid/txtAttack.dto = value
	$modsGrid/spnScale.dto = value
	$modsGrid/spnAtkExc.dto = value
	$modsGrid/spnDefExc.dto = value
	$modsGrid/spnCdExc.dto = value
	$modsGrid/spnAtkTgt.dto = value
	$modsGrid/spnDefTgt.dto = value
	$modsGrid/spnCdTgt.dto = value
	
	_on_spn_pre_value_changed(value.cdPre)
	_on_spn_post_value_changed(value.cdPos)


func _getCdPreview(cd : int) -> String:
	return _PREVIEW_MASK % (1000.0 * GameParameters.GCD * cd / 1000.0)


func _on_spn_pre_value_changed(value: float) -> void:
	$cdGrid/lblPrePreview.text = _getCdPreview(value)


func _on_spn_post_value_changed(value: float) -> void:
	$cdGrid/lblPostPreview.text = _getCdPreview(value)

