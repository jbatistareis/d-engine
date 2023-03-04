extends BaseParameters


func _ready() -> void:
	$idGrid/optType.valuesFunc = func(): return ["PC", "NPC", "FOE"]
	$miscGrid/optVerdict.valuesFunc = func(): return Persistence.listEntities(Enums.EntityType.VERDICT)
	$miscGrid/optInventory.valuesFunc = func(): return Persistence.listEntities(Enums.EntityType.INVENTORY)
	$miscGrid/optModel.valuesFunc = func(): return Persistence.listEntities(Enums.EntityType.CHARACTER_MODEL)


func setDto(value : CharacterDTO) -> void:
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$idGrid/optType.dto = value
	$lvlGrid/spnCurrLvl.dto = value
	$lvlGrid/spnExp.dto = value
	$lvlGrid/spnSparePts.dto = value
	$hpGrid/spnBase.dto = value
	$hpGrid/spnCurr.dto = value
	$hpGrid/spnExtra.dto = value
	$statsContainer/dmg/spnBase.dto = value
	$statsContainer/statsGrid/spnCon.dto = value
	$statsContainer/statsGrid/spnStr.dto = value
	$statsContainer/statsGrid/spnDex.dto = value
	$miscGrid/optVerdict.dto = value
	$miscGrid/chkVerdict.dto = value
	$miscGrid/optInventory.dto = value
	$miscGrid/optModel.dto = value


func _on_spn_con_value_changed(value: float) -> void:
	$hpGrid/spnCurr.max_value = $hpGrid/spnBase.value + value


func _on_opt_verdict_item_selected(index: int) -> void:
	ToolSignals.previewedVerdict.emit($miscGrid/optVerdict.get_item_text(index))


func _on_opt_inventory_item_selected(index: int) -> void:
	ToolSignals.previewedInventory.emit($miscGrid/optInventory.get_item_text(index))


func _on_opt_model_item_selected(index: int) -> void:
	ToolSignals.previewedModel.emit($miscGrid/optModel.get_item_text(index))


func _on_btn_vw_verdict_pressed() -> void:
	ToolSignals.previewedVerdict.emit($miscGrid/optVerdict.get_item_text($miscGrid/optVerdict.selected))


func _on_btn_vw_inventory_pressed() -> void:
	ToolSignals.previewedInventory.emit($miscGrid/optInventory.get_item_text($miscGrid/optInventory.selected))


func _on_btn_vw_model_pressed() -> void:
	ToolSignals.previewedModel.emit($miscGrid/optModel.get_item_text($miscGrid/optModel.selected))

