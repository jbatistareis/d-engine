class_name BattleSkillsWindow
extends GuiWindowModel

const SKILL_TEXT : String = '%s  [pre: %d, pos: %d]'


# TODO
func _init() -> void:
	var player = LocationManager.player if (LocationManager.player != null) else Character.new()
	
	for move in player.moves:
		buttons.append(GuiButtonModel.new(SKILL_TEXT % [move.name, move.cdPre, move.cdPost], Enums.GuiAction.CONFIRM, move))
	
	buttons.append(GuiButtonModel.new('< Back', Enums.GuiAction.CANCEL))

