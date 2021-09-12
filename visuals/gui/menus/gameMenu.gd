class_name GameMenu
extends GuiWindowModel


func _init() -> void:
	buttons.append_array([
		GuiButtonModel.new('Action ', Enums.GuiAction.CONFIRM, true),
		GuiButtonModel.new('Map   >', Enums.GuiAction.NEW_WINDOW, MapWindow.new()),
		GuiButtonModel.new('Items >', Enums.GuiAction.NEW_WINDOW, ItemsWindow.new()),
		GuiButtonModel.new('Equip >', Enums.GuiAction.NEW_WINDOW, EquipmentWindow.new()),
		GuiButtonModel.new('Moves >', Enums.GuiAction.NEW_WINDOW, MovesWindow.new()),
		GuiButtonModel.new('Conf  >', Enums.GuiAction.NEW_WINDOW, OptionsWindow.new()),
		GuiButtonModel.new('< Close')
	])
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.25,
		OverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
	pass

