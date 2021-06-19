class_name GameMenu
extends GuiWindowModel


func _init() -> void:
	buttons.append_array([
		GuiButtonModel.new('Map   >', Enums.GuiAction.NEW_WINDOW, MapWindow.new()),
		GuiButtonModel.new('Items >', Enums.GuiAction.NEW_WINDOW, ItemsWindow.new()),
		GuiButtonModel.new('Equip >', Enums.GuiAction.NEW_WINDOW, EquipmentWindow.new()),
		GuiButtonModel.new('Skill >', Enums.GuiAction.NEW_WINDOW, SkillsWindow.new()),
		GuiButtonModel.new('Conf  >', Enums.GuiAction.NEW_WINDOW, OptionsWindow.new()),
		GuiButtonModel.new('< Close')
	])
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.18,
		OverlayManager.windowSize().y * 0.3
	)

