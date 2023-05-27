extends BaseParameters

var moves : Array


func _ready() -> void:
	$statsGrid/optStatMod.valuesFunc = func(): return ["None", "STR", "DEX", "CON"]
	$statsGrid/optModifierDice.valuesFunc = func(): return ["None", "D4", "D6", "D8", "D10", "D12", "D20", "D100"]
	$statsGrid/optRollType.valuesFunc = func(): return ["None", "Best", "Normal", "Worst"]
	
	$moveGrid/optMove1.valuesFunc = _createMovesList
	$moveGrid/optMove2.valuesFunc = _createMovesList
	$moveGrid/optMove3.valuesFunc = _createMovesList


func _createMovesList() -> Array:
	var result = ["None"]
	result.append_array(Persistence.listEntities(Enums.EntityType.MOVE))
	
	return result


func setDto(value : WeaponDTO) -> void:
	moves = _createMovesList()
	
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	$statsGrid/spnDamage.dto = value
	$statsGrid/optModifierDice.dto = value
	$statsGrid/optRollType.dto = value
	$statsGrid/optStatMod.dto = value
	$moveGrid/optMove1.dto = value
	$moveGrid/optMove2.dto = value
	$moveGrid/optMove3.dto = value
	
	$moveGrid/btnEditMove1.disabled = value.move1ShortName.is_empty()
	$moveGrid/btnEditMove2.disabled = value.move2ShortName.is_empty()
	$moveGrid/btnEditMove3.disabled = value.move3ShortName.is_empty()


func _on_btn_edit_move_1_pressed() -> void:
	ToolSignals.selectedMove.emit(moves[$moveGrid/optMove1.selected])


func _on_btn_edit_move_2_pressed() -> void:
	ToolSignals.selectedMove.emit(moves[$moveGrid/optMove2.selected])


func _on_btn_edit_move_3_pressed() -> void:
	ToolSignals.selectedMove.emit(moves[$moveGrid/optMove3.selected])


func _on_opt_move_1_item_selected(index: int) -> void:
	$moveGrid/btnEditMove1.disabled = (index == 0)


func _on_opt_move_2_item_selected(index: int) -> void:
	$moveGrid/btnEditMove2.disabled = (index == 0)


func _on_opt_move_3_item_selected(index: int) -> void:
	$moveGrid/btnEditMove3.disabled = (index == 0)

