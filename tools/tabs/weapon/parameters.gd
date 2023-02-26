extends BaseParameters

var moves : Array


func _ready() -> void:
	moves.clear()
	moves.append("None")
	moves.append_array(Persistence.listEntities(Enums.EntityType.MOVE))
	
	$moveGrid/optMove1.itemList = moves
	$moveGrid/optMove2.itemList = moves
	$moveGrid/optMove3.itemList = moves


func setDto(value : WeaponDTO) -> void:
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

