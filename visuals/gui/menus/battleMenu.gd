class_name BattleMenu
extends GuiWindowModel


func _init() -> void:
	buttons.append_array([
		GuiButtonModel.new('Attack', Enums.GuiAction.CONFIRM, null), # TODO
		GuiButtonModel.new('Skill >', Enums.GuiAction.NEW_WINDOW, BattleSkillsWindow.new()),
		GuiButtonModel.new('Defend', Enums.GuiAction.CONFIRM, null), # TODO
	])
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.18,
		OverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
	print(data)

